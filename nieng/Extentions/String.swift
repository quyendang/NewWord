//
//  String.swift
//  nieng
//
//  Created by Quyen Dang on 17/07/2023.
//

import Foundation
import CryptoKit
import SwiftUI

extension String {
    var hiddenString: String {
        let asterisksCount = self.count
        let asterisks = String(repeating: "*", count: asterisksCount)
        return asterisks
    }
    
    func countWords() -> Int {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        let nonEmptyComponents = components.filter { !$0.isEmpty }
        return nonEmptyComponents.count
    }
    
    var pathWord: String {
        let replacedString = self.replacingOccurrences(of: " ", with: "-")
        return replacedString
    }
    
    var sha256: String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    
    
    var wordColor: Color {
        return self == "noun" ? Color.greenPro: self == "verb" ?  Color.redPro: self == "adjective" ? Color.pinkPro: self == "pronoun" ? Color.bluePro : self == "adverb" ? Color.yellowPro : Color.orangePro
    }
    
}

extension String {
   func base64Encoded() -> String? {
      data(using: .utf8)?.base64EncodedString()
   }
   func base64Decoded() -> String? {
      guard let data = Data(base64Encoded: self) else { return nil }
      return String(data: data, encoding: .utf8)
   }
}
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return self.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
