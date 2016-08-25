//
//  ApnListViewController+Previewing.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
extension ApnListViewController: UIViewControllerPreviewingDelegate {
    // MARK: UIViewControllerPreviewingDelegate
    
    /// Create a previewing view controller to be shown at "Peek".
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // Obtain the index path and the cell that was pressed.
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        // Create a detail view controller and set its properties.
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailApnViewController") as? DetailApnViewController else { return nil }
        
        detailViewController.myApnSummaryObject = allApnSummaryObjs.objectAtIndex(UInt((indexPath.row))) as! ApnSummaryObject
        
        /*
         Set the height of the preview by setting the preferred content size of the detail view controller.
         Width should be zero, because it's not used in portrait.
         */
        detailViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        // Set the source rect to the cell frame, so surrounding elements are blurred.
        previewingContext.sourceRect = cell.frame
        
        return detailViewController
    }
    
    /// Present the view controller for the "Pop" action.
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        // Reuse the "Peek" view controller for presentation.
        showViewController(viewControllerToCommit, sender: self)
    }
}