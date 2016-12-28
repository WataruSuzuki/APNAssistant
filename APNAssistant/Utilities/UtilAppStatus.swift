//
//  UtilAppStatus.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/09/24.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilAppStatus: NSObject {

    var indicator: UIActivityIndicatorView!
    
    func startCheckActualAppVersion() {
        let path = DownloadProfiles.serverUrl + DownloadProfiles.resourcesDir + "version.json"
        let reqUrl = URL(string: path)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.downloadTask(with: reqUrl!, completionHandler: { (location, response, error) in
            guard let thisResponse = response else { return }
            guard let thisLocation = location else { return }
            
            let helper = AvailableCountriesHelper()
            let filePath = helper.moveJSONByURLResponse(thisResponse, location: thisLocation)
            let localUrl = URL(fileURLWithPath: filePath)
            if let jsonData = try? Data(contentsOf: localUrl) {
                helper.parseVersionCheckJson(jsonData)
            }
            session.invalidateAndCancel()
        }) 
        
        task.resume()
    }
    
    func isAvailableAllFunction() -> Bool {
        #if DEBUG
            //allways available
        #else
            if !UtilUserDefaults().isAvailableStore
                || isAppUpdated()
            {
                return false
            }
        #endif
        return true
    }
    
    func isAppUpdated() -> Bool {
        #if false//FULL_VERSION
            //do nothing
        #else
            let ud = UtilUserDefaults()
            let actualVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let memoryVersion = ud.memoryVersion
            print("actualVersion = \(actualVersion)")
            print("memoryVersion = \(memoryVersion)")
            
            let compareResult = memoryVersion.compare(actualVersion, options: .numeric)
            print("compareResult = \(compareResult.rawValue)")
            if compareResult == .orderedAscending {
                ud.isAvailableStore = false
                return true
            }
        #endif
        return false
    }
    
    func getIndicatorFrame(_ scrollView: UIScrollView) -> CGRect {
        return CGRect(origin: scrollView.contentOffset, size: scrollView.frame.size)
    }
    
    func startIndicator(_ currentView: UIScrollView) {
        indicator = UIActivityIndicatorView(frame: getIndicatorFrame(currentView))
        //indicator.center = self.view.center
        indicator.backgroundColor = UIColor.darkGray
        indicator.alpha = 0.5
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.startAnimating()
        currentView.addSubview(indicator)
    }
    
    func stopIndicator() {
        indicator.removeFromSuperview()
    }
    
    func isShowImportantMenu() -> Bool {
        #if DEBUG
            return true
        #elseif STAND_ALONE_VERSION
            return UIApplication.sharedApplication().canOpenURL(NSURL(string: "jchankchandatausagecat://")!)
        #elseif FULL_VERSION
            return UtilAppStatus().isAvailableAllFunction()
        #else
            return true
        #endif
    }
    
    func showCautionProfile(_ sender: Any) {
        let title = NSLocalizedString("caution", comment: "")
        let message = NSLocalizedString("caution_profile", comment: "")
        let negativeMessage = NSLocalizedString("cancel", comment: "")
        let positiveMessage = NSLocalizedString("understand", comment: "")
        
        var actions = [Any]()
        if #available(iOS 8.0, *) {
            let controller = sender as! UIViewController
            let cancelAction = UIAlertAction(title: negativeMessage, style: UIAlertActionStyle.cancel){
                action in //do nothing
            }
            let installAction = UIAlertAction(title: positiveMessage, style: UIAlertActionStyle.destructive){
                action in controller.performSegue(withIdentifier: "EditApnViewController", sender: controller)
            }
            actions.append(cancelAction)
            actions.append(installAction)
        } else {
            actions.append(positiveMessage)
            actions.append(negativeMessage)
        }
        
        UtilAlertSheet.showSheetController(title, message: message, actions: actions, sender: sender)
    }
    
    func showStatuLimitByApple(_ vc: UIViewController){
        UtilAlertSheet.showAlertController("error", messagekey: "fail_bacause_apple_not_permit", url: URL(string: "https://support.apple.com/HT201699"), vc: vc)
    }
}
