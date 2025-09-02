//
//  MD5Manager.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/21/25.
//
import Foundation
import CommonCrypto

struct MD5Manager {
    static func hash(_ input: String) -> String {
        let data = Data(input.utf8)
        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digest.withUnsafeMutableBytes { digestBytes -> UInt8 in
            data.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress,
                   let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    CC_MD5(messageBytesBaseAddress, CC_LONG(data.count), digestBytesBlindMemory)
                }
                return 0
            }
        }

        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
