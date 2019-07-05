//
//  AppStatus+Stable.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2019/09/09.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

extension UtilAppStatus {
    
    fileprivate struct Default {
        static let available_appstore = false
        static let memory_version = "0.0.0"
    }
    
    func startCheckActualAppVersion() {
        // (・∀・)
    }
    
    func isAvailableAllFunction() -> Bool {
        // (・∀・)
        return true
    }
    
    func isShowImportantMenu() -> Bool {
        return UtilAppStatus().isAvailableAllFunction()
    }
    
    func showCautionProfile(_ sender: Any) {
        let title = NSLocalizedString("caution", comment: "")
        let message = NSLocalizedString("caution_profile", comment: "")
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("understand", comment: "")
        
        var actions = [Any]()
        if #available(iOS 8.0, *) {
            let controller = sender as! UIViewController
            let cancelAction = UIAlertAction(title: negativeMessage, style: .cancel){
                action in //do nothing
            }
            let installAction = UIAlertAction(title: positiveMessage, style: .destructive){
                action in controller.performSegue(withIdentifier: "EditApnViewController", sender: controller)
            }
            actions.append(cancelAction)
            actions.append(installAction)
        } else {
            actions.append(positiveMessage)
            actions.append(negativeMessage)
        }
        
        UtilAlertSheet.showSheetController(title, message: message, actions: actions, sender: sender)
    }
    
    func showStatuLimitByApple(_ vc: UIViewController){
        UtilAlertSheet.showAlertController("error", messagekey: "fail_bacause_apple_not_permit", url: URL(string: "https://support.apple.com/HT201699"), vc: vc)
    }

}
