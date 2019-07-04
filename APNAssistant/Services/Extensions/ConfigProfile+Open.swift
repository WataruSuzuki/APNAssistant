//
//  ConfigProfile+Open.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2019/09/29.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

extension ConfigProfileService {
    
    func updateProfile(_ rlmObject: UtilHandleRLMObject) {
        writeMobileConfigProfile(rlmObject, fileName: fileNameSetting)
        bridger.startCocoaHTTPServer()
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(bridger.url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(bridger.url)
        }
    }
    
}
