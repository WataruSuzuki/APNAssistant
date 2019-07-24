//
//  String+Capture.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2019/06/11.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

extension String {

    public func capture(pattern: String, group: Int) -> String? {
        let result = capture(pattern: pattern, group: [group])
        return result.isEmpty ? nil : result[0]
    }

    public func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        guard let matched = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)) else {
            return []
        }

        return group.map { group -> String in
            return (self as NSString).substring(with: matched.range(at: group))
        }
    }
}
