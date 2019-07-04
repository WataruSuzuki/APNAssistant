//
//  ApnList+ContextMenu.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2019/09/28.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

extension ApnListViewController {
    
    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let previewProvider: () -> DetailApnViewController? = { [unowned self] in
            //guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
            
            guard let targetController = self.storyboard?.instantiateViewController(withIdentifier: "DetailApnViewController") as? DetailApnViewController else { return nil }
            targetController.delegate = self
            targetController.myApnSummaryObject = self.allApnSummaryObjs.object(at: UInt((indexPath.row))) as! ApnSummaryObject
            
            //targetController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            //previewingContext.sourceRect = cell.frame
            
            return targetController
        }

        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            let menuArray = DetailApnViewController().loadMenuArray()
            
            let setApn = UIAction(title: menuArray[DetailApnViewController.DetailMenu.setThisApnToDevice.rawValue], image: UIImage(systemName: "link.circle"), attributes: .destructive) { _ in
                let targetObj = self.targetProfileObj(indexPath: indexPath)
                self.configProfileService.updateProfile(targetObj)
            }
            let share = UIAction(title: menuArray[DetailApnViewController.DetailMenu.share.rawValue], image: UIImage(systemName: "square.and.arrow.up")) { (action) in
                let targetObj = self.targetProfileObj(indexPath: indexPath)
                UtilShareAction.handleShareApn(self.configProfileService, obj: targetObj, sender: self)
            }
            let edit = UIAction(title: menuArray[DetailApnViewController.DetailMenu.edit.rawValue], image: UIImage(systemName: "square.and.pencil")) { (action) in
                self.selectEditAction(self.summaryObj(indexPath: indexPath))
            }
//            let editMenu: UIMenu = {
//                let copy = UIAction(title: "Copy", image: nil) { _ in
//                    // some action
//                }
//                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { _ in
//                    // some action
//                }
//                return UIMenu(__title: "Edit..", image: nil, identifier: nil, children: [copy, delete])
//            }()
//
            //return UIMenu(__title: "Edit..", image: nil, identifier: nil, children: [share, editMenu])
            if self.appStatus.isShowImportantMenu() {
                return UIMenu(title: "", image: nil, identifier: nil, children: [setApn, share, edit])
            } else {
                return UIMenu(title: "", image: nil, identifier: nil, children: [share, edit])
            }
        }

        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: previewProvider,
                                          actionProvider: actionProvider)
    }
    
    private func summaryObj(indexPath: IndexPath) -> ApnSummaryObject {
        return allApnSummaryObjs.object(at: UInt(((indexPath as NSIndexPath?)?.row)!)) as! ApnSummaryObject
    }
    
    private func targetProfileObj(indexPath: IndexPath) -> UtilHandleRLMObject {
        let summary = summaryObj(indexPath: indexPath)
        return UtilHandleRLMObject(id: summary.id, profileObj: summary.apnProfile!, summaryObj: summary)
        //targetObj.prepareKeepApnProfileColumn(summary.apnProfile!)
    }
}
