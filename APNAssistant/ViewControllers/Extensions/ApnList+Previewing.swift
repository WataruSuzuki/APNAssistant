//
//  ApnListViewController+Previewing.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
extension ApnListViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let targetController = storyboard?.instantiateViewController(withIdentifier: "DetailApnViewController") as? DetailApnViewController else { return nil }
        targetController.delegate = self
        targetController.myApnSummaryObject = allApnSummaryObjs.object(at: UInt((indexPath.row))) as! ApnSummaryObject
        
        targetController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        previewingContext.sourceRect = cell.frame
        
        return targetController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
