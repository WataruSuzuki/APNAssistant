//
//  UtilAppStatus.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAppStatus: NSObject {

    func checkActualAppVersion() {
        let path = DownloadProfiles.serverUrl + DownloadProfiles.apnProfilesDir + "resources/version.json"
        let reqUrl = NSURL(string: path)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.downloadTaskWithURL(reqUrl!) { (location, response, error) in
            guard let thisResponse = response else { return }
            guard let thisLocation = location else { return }
            
            let helper = AvailableUpdateHelper()
            helper.moveJSONFilesFromURLResponse(thisResponse, location: thisLocation, isCheckVersion: true)
            session.invalidateAndCancel()
        }
        
        task.resume()
    }
    
    func isAvailableAllFunction() -> Bool {
//        if !UtilUserDefaults().isAvailableStore
//            || !UtilUserDefaults().isSignInSuccess
//            || isAppUpdated() {
//            return false
//        }
        return true
    }
    
    func checkAccountAuth() -> Bool {
//        if let auth = FIRAuth.auth() {
//            if let user = auth.currentUser {
//                checkSignInSuccess(user.email!)
//                return true
//            }
//        }
//        UtilUserDefaults().isSignInSuccess = false
//        return false
        return true
    }
    
    func checkSignInSuccess(userEmail: String) -> Bool {
//        let status = (userEmail != "devjchankchan@gmail.com")
//        UtilUserDefaults().isSignInSuccess = status
//        return status
        return true
    }
    
    func isAppUpdated() -> Bool {
//        let ud = UtilUserDefaults()
//        let actualVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
//        let memoryVersion = ud.memoryVersion
//        //        print("actualVersion = \(actualVersion)")
//        //        print("memoryVersion = \(memoryVersion)")
//        
//        let compareResult = memoryVersion.compare(actualVersion, options: .NumericSearch)
//        //        print("compareResult = \(compareResult.rawValue)")
//        if compareResult == .OrderedAscending {
//            ud.isAvailableStore = false
            return true
//        }
//        return false
    }
    
}
