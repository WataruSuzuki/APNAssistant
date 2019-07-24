//
//  UIViewController+Activity.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2019/01/07.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

extension UIViewController {

    static public func getActivityViewController(items: [Any]) -> UIActivityViewController {
        let contoller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        contoller.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print
        ]

        return contoller
    }
}
