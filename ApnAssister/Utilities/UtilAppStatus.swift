//
//  UtilAppStatus.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAppStatus: NSObject {

    var indicator: UIActivityIndicatorView!
    
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
        #if DEBUG_SWIFT_XCODE7
            //allways available
        #else
            if !UtilUserDefaults().isAvailableStore
                || !UtilUserDefaults().isSignInSuccess
                || isAppUpdated()
            {
                return false
            }
        #endif
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
        #if false//IS_APN_ASSISTER
            //do nothing
        #else
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
    
    func getIndicatorFrame(scrollView: UIScrollView) -> CGRect {
        return CGRect(origin: scrollView.contentOffset, size: scrollView.frame.size)
    }
    
    func startIndicator(currentView: UIScrollView) {
        indicator = UIActivityIndicatorView(frame: getIndicatorFrame(currentView))
        //indicator.center = self.view.center
        indicator.backgroundColor = UIColor.darkGrayColor()
        indicator.alpha = 0.5
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        currentView.addSubview(indicator)
    }
    
    func stopIndicator() {
        indicator.removeFromSuperview()
    }
    
    func isShowImportantMenu() -> Bool {
        #if DEBUG_SWIFT_XCODE7
            return true
        #elseif IS_APN_MEMO
            return UIApplication.sharedApplication().canOpenURL(NSURL(string: "jchankchanapnbookmarks://")!)
        #elseif IS_APN_BOOKMARKS
            return UIApplication.sharedApplication().canOpenURL(NSURL(string: "jchankchanapnmemo://")!)
        #elseif IS_APN_ASSISTER
            return UtilAppStatus().isAvailableAllFunction()
        #else
            return true
        #endif
    }
    
    func showCautionProfile(sender: AnyObject) {
        let title = NSLocalizedString("caution", comment: "")
        let message = NSLocalizedString("caution_profile", comment: "")
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("understand", comment: "")
        
        var actions = [AnyObject]()
        if #available(iOS 8.0, *) {
            let controller = sender as! UIViewController
            let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.Cancel){
                action in //do nothing
            }
            let installAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.Destructive){
                action in controller.performSegueWithIdentifier("EditApnViewController", sender: controller)
            }
            actions.append(cancelAction)
            actions.append(installAction)
        } else {
            actions.append(positiveMessage)
            actions.append(negativeMessage)
        }
        
        UtilAlertSheet.showSheetController(title, message: message, actions: actions, sender: sender)
    }
    
    func showStatuLimitByApple(vc: UIViewController){
        UtilAlertSheet.showAlertController("error", messagekey: "fail_bacause_apple_not_permit", url: NSURL(string: "https://support.apple.com/HT201699"), vc: vc)
    }
}
