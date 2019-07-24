//
//  UITableView+CustomNib.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki 2018/10/04.
//  Copyright © 2018年 WataruSuzuki. All rights reserved.
//

import Foundation

extension UITableView {
    public func registerCustomCell(_ nibIdentifier: String) {
        let nib = UINib(nibName: nibIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: nibIdentifier)
    }
}
