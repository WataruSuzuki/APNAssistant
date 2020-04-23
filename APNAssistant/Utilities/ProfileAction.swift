//
//  ProfileAction.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import SafariServices

class ProfileAction: NSObject {
    static func open(url: URL, sender: UIViewController?) {
        if #available(iOS 14.0, *) {
            if let controller = sender {
                let safari = SFSafariViewController(url: url)
                controller.present(safari, animated: true, completion: nil)
                return
            }
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func share(_ httpServer: ConfigProfileService, obj: UtilHandleRLMObject, sender: UIViewController) {
        let configProfileUrl = httpServer.getProfileUrl(obj)
        
        let contoller = UIActivityViewController(activityItems: [configProfileUrl], applicationActivities: nil)
        contoller.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.print
        ]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            contoller.popoverPresentationController?.barButtonItem = sender.navigationItem.rightBarButtonItem
        }
        sender.present(contoller, animated: true, completion: nil)
    }
}
