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
        let path = DownloadProfiles.serverUrl + DownloadProfiles.resourcesDir + "version.json"
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
        if !UtilUserDefaults().isAvailableStore
//            || !UtilUserDefaults().isSignInSuccess
            || isAppUpdated() 
        {
            return false
        }
        return true
    }
    
    func checkAccountAuth() -> Bool {
        #if false
            if let auth = FIRAuth.auth() {
                if let user = auth.currentUser {
                    checkSignInSuccess(user.email!)
                    return true
                }
            }
            UtilUserDefaults().isSignInSuccess = false
            return false
        #endif
        return true
    }
    
    func checkSignInSuccess(userEmail: String) -> Bool {
        #if false
            let status = (userEmail != "devjchankchan@gmail.com")
            UtilUserDefaults().isSignInSuccess = status
            return status
        #endif
        return true
    }
    
    func isAppUpdated() -> Bool {
        #if false
            let ud = UtilUserDefaults()
            let actualVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
            let memoryVersion = ud.memoryVersion
            print("actualVersion = \(actualVersion)")
            print("memoryVersion = \(memoryVersion)")
            
            let compareResult = memoryVersion.compare(actualVersion, options: .NumericSearch)
            print("compareResult = \(compareResult.rawValue)")
            if compareResult == .OrderedAscending {
                ud.isAvailableStore = false
                return true
            }
        #endif
        return false
    }
    
    func isShowImportantMenu() -> Bool {
        #if IS_APN_MEMO
            return UIApplication.sharedApplication().canOpenURL(NSURL(string: "jchankchanapnbookmarks://")!)
        #elseif IS_APN_MEMO
            return UIApplication.sharedApplication().canOpenURL(NSURL(string: "jchankchanapnmemo://")!)
        #else
            return true
        #endif
    }
    
    func showComfirmOldAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: buttonText)
        alert.show()
    }
    
    func showFailAlertController(key: String, url: NSURL?, vc: UIViewController){
        let buttonText = "OK"
        let title = NSLocalizedString("error", comment: "")
        let message = NSLocalizedString(key, comment: "")
        if #available(iOS 8.0, *) {
            let okAction = UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default){
                action in
                if nil != url {
                    UIApplication.sharedApplication().openURL(url!)
                }
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(okAction)
            vc.presentViewController(alertController, animated: true, completion: nil)
        } else {
            showComfirmOldAlert(title, message: message, buttonText: buttonText)
        }
    }
}
