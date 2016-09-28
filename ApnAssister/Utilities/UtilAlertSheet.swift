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
}
