//
//  Enum+Description.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2019/06/05.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue : Any {
    public var describing: String {
        get { return String(describing: self) }
    }
}
