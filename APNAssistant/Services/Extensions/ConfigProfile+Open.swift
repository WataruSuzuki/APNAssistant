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
            UIApplication.shared.open(bridger.url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(bridger.url)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
