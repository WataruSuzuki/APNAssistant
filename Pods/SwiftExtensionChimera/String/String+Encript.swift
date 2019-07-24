//
//  String+Encript.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki 2018/10/22.
//  Copyright © 2018年 WataruSuzuki. All rights reserved.
//

import CommonCrypto

extension String {

    public var sha1: String {
        get {
            let data = self.data(using: .utf8)!
            let length = Int(CC_SHA1_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            _ = data.withUnsafeBytes { CC_SHA1($0, CC_LONG(data.count), &digest) }
            let crypt = digest.map { String(format: "%02x", $0) }.joined(separator: "")
            debugPrint("crypt : \(crypt)")

            return crypt
        }
    }

    public var md5: String {
        get {
            let data = self.data(using: .utf8)!
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            _ = data.withUnsafeBytes { CC_MD5($0, CC_LONG(data.count), &digest) }
            let crypt = digest.map { String(format: "%02x", $0) }.joined(separator: "")
            debugPrint("md5 : \(crypt)")

            return crypt
        }
    }

    public func sha1(with param: String) -> String {
        let str = "\(self)_\(param)"
        let data = str.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        let crypt = hexBytes.joined()
        debugPrint("sha1 : \(crypt)")

        return crypt
    }

    public func md5(with param: String) -> String {
        let str = "\(self)_\(param)"
        let data = str.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        let crypt = hexBytes.joined()
        debugPrint("md5 : \(crypt)")

        return crypt
    }
}
