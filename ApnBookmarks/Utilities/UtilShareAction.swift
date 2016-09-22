//
//  UtilShareAction.swift
//  ApnBookmarks
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilShareAction: NSObject {

    static func handleShareApn(httpServer: UtilCocoaHTTPServer, obj: UtilHandleRLMObject, sender: UIViewController){
        let configProfileUrl = httpServer.getProfileUrl(obj)
        
        let contoller = UIActivityViewController(activityItems: [configProfileUrl], applicationActivities: nil)
        contoller.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]
        
        if #available(iOS 8.0, *) {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                contoller.popoverPresentationController?.barButtonItem = sender.navigationItem.rightBarButtonItem
            }
        }
        
        sender.presentViewController(contoller, animated: true, completion: nil)
    }
}
