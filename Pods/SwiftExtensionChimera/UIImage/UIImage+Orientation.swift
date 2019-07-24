//
//  UIImage+Orientation.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2018/11/06.
//  Copyright © 2018 WataruSuzuki. All rights reserved.
//

import Foundation

extension UIImage {
    public func transformToUp () -> UIImage {
        guard self.imageOrientation != .up else { return self }
        
        var transform = CGAffineTransform.identity
        let width = self.size.width
        let height = self.size.height

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat.pi / 2 * -1 )
        default: // o.Up, o.UpMirrored:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let cgimage = self.cgImage

        let ctx = CGContext(data: nil, width: Int(width), height: Int(height),
                            bitsPerComponent: cgimage!.bitsPerComponent, bytesPerRow: 0,
                            space: cgimage!.colorSpace!,
                            bitmapInfo: cgimage!.bitmapInfo.rawValue)

        ctx!.concatenate(transform)

        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgimage!, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            ctx?.draw(cgimage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        let cgimg = ctx!.makeImage()
        let img = UIImage(cgImage: cgimg!)
        return img
    }
}
