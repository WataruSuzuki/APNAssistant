//
//  String+Localized.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2019/01/09.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

extension String {

    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }

//    public var localized: String {
//        return NSLocalizedString(self, tableName: "TableName", comment: "")
//    }
}
