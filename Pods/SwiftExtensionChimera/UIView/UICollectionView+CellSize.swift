//
//  UICollectionView+CellSize.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2018/10/18.
//  Copyright © 2018 WataruSuzuki. All rights reserved.
//

import Foundation

extension UICollectionView {

    public func getCellSize(baseCellNum: Int) -> CGSize {
        let cellNum = (UIDevice.current.userInterfaceIdiom == .pad ? baseCellNum * 2 : baseCellNum)
        let cardSize = (fmin(bounds.size.width, bounds.size.height) / CGFloat(cellNum)) - 12
        return CGSize(width: cardSize, height: cardSize)
    }
}
