//
//  ConfigProfile+Open.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2019/09/29.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

extension ConfigProfileService {
    
    func updateProfile(_ rlmObject: UtilHandleRLMObject, sender: UIViewController) {
        writeMobileConfigProfile(rlmObject, fileName: fileNameSetting)
        bridger.startCocoaHTTPServer()
        
        ProfileAction.open(url: bridger.url, sender: sender)
    }
    
}
