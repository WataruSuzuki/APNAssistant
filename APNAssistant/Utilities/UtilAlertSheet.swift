//
//  UtilAlertSheet.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/28.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAlertSheet: NSObject {

    class func showAlertController(_ titlekey: String, messagekey: String, url: URL?, vc: UIViewController){
        let buttonText = "OK"
        let title = NSLocalizedString(titlekey, comment: "")
        let message = NSLocalizedString(messagekey, comment: "")
        let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.default){
            action in
            if nil != url {
                UIApplication.shared.openURL(url!)
            }
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showSheetController(_ title: String, message: String, actions: [Any], sender: Any){
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
    }
    
}
