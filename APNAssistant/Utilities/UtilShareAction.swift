//
//  UtilShareAction.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilShareAction: NSObject {

    static func handleShareApn(_ httpServer: UtilCocoaHTTPServer, obj: UtilHandleRLMObject, sender: UIViewController){
        let configProfileUrl = httpServer.getProfileUrl(obj)
        
        let contoller = UIActivityViewController(activityItems: [configProfileUrl], applicationActivities: nil)
        contoller.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print
        ]
        
        if #available(iOS 8.0, *) {
            if UIDevice.current.userInterfaceIdiom == .pad {
                contoller.popoverPresentationController?.barButtonItem = sender.navigationItem.rightBarButtonItem
            }
        }
        
        sender.present(contoller, animated: true, completion: nil)
    }
}
