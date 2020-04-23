//
//  ProfileAction.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class ProfileAction: NSObject {

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
