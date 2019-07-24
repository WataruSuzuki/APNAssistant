//
//  AlertControl+Cancel.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki 2018/10/17.
//  Copyright © 2018年 WataruSuzuki. All rights reserved.
//

import Foundation

extension UIAlertController {

    public func addCancelAction(handler: ((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(title: "cancel".localized, style: .cancel, handler: handler)
        self.addAction(action)
    }

    public func addEmptyCancelAction() {
        addCancelAction(handler: nil)
    }

    public func addEmptyOkAction() {
        let action = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        self.addAction(action)
    }
}
