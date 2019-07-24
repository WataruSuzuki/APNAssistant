//
//  UIViewController+Top.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki 2018/10/17.
//  Copyright © 2018年 WataruSuzuki. All rights reserved.
//

import UIKit
import PureLayout

extension UIViewController {

    static public func currentTop() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    static public func topIndicatorStart() -> UIView? {
        if let top = currentTop() {
            let background = UIView(frame: top.view.bounds)
            background.backgroundColor = .gray
            background.isOpaque = true
            background.alpha = 0.5
            let indicator = UIActivityIndicatorView(frame: .zero)
            indicator.activityIndicatorViewStyle = .whiteLarge
            top.view.addSubview(background)
            background.autoPinEdgesToSuperviewEdges()
            background.addSubview(indicator)
            indicator.autoCenterInSuperview()
            indicator.startAnimating()

            return background
        }
        return nil
    }

    static public func topIndicatorStop(view: UIView?) {
        if let view = view {
            view.removeFromSuperview()
        }
    }
}
