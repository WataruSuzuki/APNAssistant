//
//  UtilAlertSheet.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/28.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAlertSheet: NSObject {

    class func showComfirmOldAlert(_ title: String, message: String, buttonText: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: buttonText)
        alert.show()
    }
    
    class func showAlertController(_ titlekey: String, messagekey: String, url: URL?, vc: UIViewController){
        let buttonText = "OK"
        let title = NSLocalizedString(titlekey, comment: "")
        let message = NSLocalizedString(messagekey, comment: "")
        if #available(iOS 8.0, *) {
            let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.default){
                action in
                if nil != url {
                    UIApplication.shared.openURL(url!)
                }
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(okAction)
            vc.present(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldAlert(title, message: message, buttonText: buttonText)
        }
    }
    
    class func showComfirmOldSheet(_ title: String, messages: [Any], tag:Int, sender: Any) {
        let sheet = UIActionSheet()
        sheet.tag = tag
        sheet.delegate = sender as? UIActionSheetDelegate
        sheet.title = title
        for message in messages {
            sheet.addButton(withTitle: message as? String)
        }
        sheet.cancelButtonIndex = 1
        sheet.destructiveButtonIndex = 0
        
        if let controller = sender as? UIViewController {
            sheet.show(in: controller.view)
        }
    }
    
    class func showSheetController(_ title: String, message: String, actions: [Any], sender: Any){
        if #available(iOS 8.0, *) {
            if let controller = sender as? UIViewController {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                for action in actions {
                    alertController.addAction(action as! UIAlertAction)
                }
                
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    alertController.popoverPresentationController?.barButtonItem = controller.navigationItem.rightBarButtonItem
                }
                
                controller.present(alertController, animated: true, completion: nil)
            }
        } else {
            showComfirmOldSheet(title + "\n" + message, messages: actions, tag: 0, sender: sender)
        }
    }
    
}
