//
//  GoogleAuthenticator.swift
//  nieng
//
//  Created by Quyen Dang on 17/07/2023.
//

import Foundation
import CommonCrypto
import CryptoKit

class GoogleAuthenticator {
    private var codeLength = 6
    private var timeStep: Int = 30
    
    func createSecret(secretLength: Int = 16) -> String {
        let validChars = getBase32LookupTable()
        
        if secretLength < 16 || secretLength > 128 {
            fatalError("Bad secret length")
        }
        
        var secret = ""
        var rnd = Data(count: secretLength)
        
#if canImport(Darwin)
        let result = SecRandomCopyBytes(kSecRandomDefault, secretLength, &rnd)
        if result != errSecSuccess {
            fatalError("No source of secure random")
        }
#else
        for i in 0..<secretLength {
            let randomValue = UInt8.random(in: 0...255)
            rnd[i] = randomValue
        }
#endif
        
        for i in 0..<secretLength {
            let index = Int(rnd[i]) & 31
            secret += String(validChars[index])
        }
        
        return secret
    }
    
    func getCode(secret: String, timeSlice: Int? = nil) -> String {
        let timeSlice = timeSlice ?? Int(Date().timeIntervalSince1970 / 30)
        let secretKey = base32Decode(secret)
        
        var time = Data(repeating: 0, count: 8)
        var timeSliceInt = timeSlice
        for i in (0..<8).reversed() {
            time[i] = UInt8(timeSliceInt & 0xff)
            timeSliceInt >>= 8
        }
        
        let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: time, using: SymmetricKey(data: secretKey))
        
        let byteArray = Array(hmac)
        let offset = Int(byteArray.last!) & 0x0f
        let truncatedHash = (UInt32(byteArray[offset]) & 0x7f) << 24
        | (UInt32(byteArray[offset + 1]) & 0xff) << 16
        | (UInt32(byteArray[offset + 2]) & 0xff) << 8
        | (UInt32(byteArray[offset + 3]) & 0xff)
        
        let modulus = Int(pow(10, Double(codeLength)))
        let code = String(format: "%0\(codeLength)d", truncatedHash % UInt32(modulus))
        return code
    }
    
    func getCodeAndTimeRemaining(secret: String, timeSlice: Int? = nil) -> (code: String, timeRemaining: Int) {
        let timeSlice = timeSlice ?? Int(Date().timeIntervalSince1970)
        let secretKey = base32Decode(secret)
        
        var time = Data(repeating: 0, count: 8)
        var timeSliceInt = timeSlice / timeStep
        for i in (0..<8).reversed() {
            time[i] = UInt8(timeSliceInt & 0xff)
            timeSliceInt >>= 8
        }
        
        let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: time, using: SymmetricKey(data: secretKey))
        
        var byteArray = [UInt8](repeating: 0, count: hmac.byteCount)
        hmac.withUnsafeBytes { buffer in
            byteArray = Array(buffer.bindMemory(to: UInt8.self))
        }
        
        let offset = Int(byteArray.last!) & 0x0f
        let truncatedHash = (UInt32(byteArray[offset]) & 0x7f) << 24
        | (UInt32(byteArray[offset + 1]) & 0xff) << 16
        | (UInt32(byteArray[offset + 2]) & 0xff) << 8
        | (UInt32(byteArray[offset + 3]) & 0xff)
        
        let modulus = Int(pow(10, Double(codeLength)))
        let code = String(format: "%0\(codeLength)d", truncatedHash % UInt32(modulus))
        
        let timeRemaining = timeStep - (timeSlice % timeStep)
        
        return (code, timeRemaining)
    }
    
    func setCodeLength(length: Int) {
        codeLength = length
    }
    
    private func base32Decode(_ secret: String) -> Data {
        let base32chars = getBase32LookupTable()
        var base32charsFlipped = [Character: Int]()
        for (index, char) in base32chars.enumerated() {
            base32charsFlipped[char] = index
        }
        
        let paddingChar = base32chars.last!
        var paddingCharCount = 0
        for char in secret.reversed() {
            if char == paddingChar {
                paddingCharCount += 1
            } else {
                break
            }
        }
        
        let allowedValues = [6, 4, 3, 1, 0]
        if !allowedValues.contains(paddingCharCount) {
            fatalError("Invalid padding")
        }
        
        var secretWithoutPadding = secret
        if paddingCharCount > 0 {
            let endIndex = secret.index(secret.endIndex, offsetBy: -paddingCharCount)
            secretWithoutPadding = String(secret[..<endIndex])
        }
        
        var binaryString = ""
        for char in secretWithoutPadding {
            guard let charIndex = base32charsFlipped[char] else {
                fatalError("Invalid character in the secret")
            }
            let charBinary = String(charIndex, radix: 2).leftPadding(toLength: 5, withPad: "0")
            binaryString += charBinary
        }
        
        var decodedData = Data()
        for i in stride(from: 0, to: binaryString.count, by: 8) {
            let startIndex = binaryString.index(binaryString.startIndex, offsetBy: i)
            let endIndex = binaryString.index(startIndex, offsetBy: 8, limitedBy: binaryString.endIndex) ?? binaryString.endIndex
            let byteBinary = String(binaryString[startIndex..<endIndex])
            if let byteValue = UInt8(byteBinary, radix: 2) {
                decodedData.append(byteValue)
            }
        }
        
        return decodedData
    }
    
    private func getBase32LookupTable() -> [Character] {
        return [
            "A", "B", "C", "D", "E", "F", "G", "H", //  7
            "I", "J", "K", "L", "M", "N", "O", "P", // 15
            "Q", "R", "S", "T", "U", "V", "W", "X", // 23
            "Y", "Z", "2", "3", "4", "5", "6", "7", // 31
            "=",  // padding char
        ]
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

