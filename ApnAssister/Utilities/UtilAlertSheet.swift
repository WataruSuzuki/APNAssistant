//
//  UtilAlertSheet.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/28.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAlertSheet: NSObject {

    class func showComfirmOldAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: buttonText)
        alert.show()
    }
    
    class func showFailAlertController(key: String, url: NSURL?, vc: UIViewController){
        let buttonText = "OK"
        let title = NSLocalizedString("error", comment: "")
        let message = NSLocalizedString(key, comment: "")
        if #available(iOS 8.0, *) {
            let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default){
                action in
                if nil != url {
                    UIApplication.sharedApplication().openURL(url!)
                }
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(okAction)
            vc.presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldAlert(title, message: message, buttonText: buttonText)
        }
    }
    
    class func showComfirmOldSheet(title: String, messages: [AnyObject], tag:Int, sender: AnyObject) {
        let sheet = UIActionSheet()
        sheet.tag = tag
        sheet.delegate = sender as? UIActionSheetDelegate
        sheet.title = title
        for message in messages {
            sheet.addButtonWithTitle(message as? String)
        }
        sheet.cancelButtonIndex = 1
        sheet.destructiveButtonIndex = 0
        
        if let controller = sender as? UIViewController {
            sheet.showInView(controller.view)
        }
    }
    
    class func showConfirmAlertController(title: String, message: String, actions: [AnyObject], sender: AnyObject){
        if #available(iOS 8.0, *) {
            if let controller = sender as? UIViewController {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
                for action in actions {
                    alertController.addAction(action as! UIAlertAction)
                }
                
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                    alertController.popoverPresentationController?.barButtonItem = controller.navigationItem.rightBarButtonItem
                }
                
                controller.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            showComfirmOldSheet(title + "\n" + message, messages: actions, tag: 0, sender: sender)
        }
    }
    
}
