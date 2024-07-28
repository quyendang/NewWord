import Foundation

let setKey = "matkhau"

func xorEncryption(clearText: String) -> String {
    if clearText.isEmpty { return "" }
    
    var encrypted = [UInt8]()
    let text = [UInt8](clearText.utf8)
    let key = [UInt8](setKey.utf8)
    let length = key.count
    
    // encrypt bytes
    for t in text.enumerated() {
        encrypted.append(t.element ^ key[t.offset % length])
    }
    
    return bytesToHexString(encrypted)
}

func xorDecryption(cypherText: String) -> String {
    if cypherText.count == 0 { return "" }
    
    
    var decrypted = [UInt8]()
    let cypher = hexStringToBytes(cypherText)
    let key = [UInt8](setKey.utf8)
    let length = key.count
    
    // decrypt bytes
    for c in cypher!.enumerated() {
        decrypted.append(c.element ^ key[c.offset % length])
    }
    
    return String(bytes: decrypted, encoding: .utf8)!
}



func bytesToHexString(_ bytes: [UInt8]) -> String {
    return bytes.map { String(format: "%02X", $0) }.joined()
}

// Chuyển đổi chuỗi hex thành [UInt8]
func hexStringToBytes(_ hexString: String) -> [UInt8]? {
    var hex = hexString
    if hex.count % 2 != 0 {
        hex = "0" + hex
    }

    var bytes = [UInt8]()
    var index = hex.startIndex

    while index < hex.endIndex {
        let nextIndex = hex.index(index, offsetBy: 2)
        if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
            bytes.append(byte)
        } else {
            return nil // Invalid hex string
        }

        index = nextIndex
    }

    return bytes
}


