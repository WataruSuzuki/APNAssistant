//
//  UIImage+Translucent.swift
//  WorldHeritageViewer
//
//  Created by WataruSuzuki on 2018/11/09.
//  Copyright © 2018 WataruSuzuki. All rights reserved.
//

import Foundation

extension UIImage {
    static public func createTranslucent(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
