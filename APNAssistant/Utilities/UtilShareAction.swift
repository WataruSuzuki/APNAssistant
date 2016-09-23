//
//  UtilShareAction.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/23.
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
        
        sender.presentViewController(contoller, animated: true, completion: nil)
    }
}
