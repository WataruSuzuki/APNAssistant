//
//  MainTabBarController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    let myUtilCocoaHTTPServer = UtilCocoaHTTPServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.appDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        loadTabBarTitle()
        
        if !UtilUserDefaults().isAvailableStore || isAppUpdated() {
            hiddenSomeTabbar()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UtilUserDefaults().isAvailableStore || isAppUpdated() {
            checkActualAppVersion()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appDidBecomeActive(notification: NSNotification) {
        if #available(iOS 9.0, *) {
            executeShortcutActions()
        }
    }
    
    @available(iOS 9.0, *)
    func executeShortcutActions() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            guard let shortcutItem = delegate.myUtilShortcutLaunch.launchedShortcutItem else {
                return
            }
            switch shortcutItem.type {
            case UtilShortcutLaunch.ShortcutIdentifier.First.type:
                self.selectedViewController = self.viewControllers![MainTabBarController.TabIndex.FavoriteList.rawValue] as! UINavigationController
                
            default:
                execureShortcutUpdateApn(shortcutItem.type)
                break
            }
            delegate.myUtilShortcutLaunch.launchedShortcutItem = nil
        }
    }
    
    func execureShortcutUpdateApn(type: String) {
        let results = ApnSummaryObject.getFavoriteLists()
        let shortcut = UtilShortcutLaunch.ShortcutIdentifier(fullType: type)
        let shortcutApn = results.objectsWithPredicate(NSPredicate(format: "id = %d", shortcut!.rawValue)).lastObject() as! ApnSummaryObject
        
        let shortcutApnObj = UtilHandleRLMObject(id: shortcutApn.id, profileObj: shortcutApn.apnProfile, summaryObj: shortcutApn)
        let url = self.myUtilCocoaHTTPServer.prepareOpenSettingAppToSetProfile(shortcutApnObj)
        UIApplication.sharedApplication().openURL(url)
    }
    
    func loadTabBarTitle() {
        var index = 0
        for item in self.tabBar.items! {
            item.title = TabIndex(rawValue: index)?.getTitle()
            index += 1
        }
    }
    
    func hiddenSomeTabbar() {
        var controllers = self.viewControllers
        controllers?.removeAtIndex(TabIndex.ProfileList.rawValue)
        controllers?.removeAtIndex(TabIndex.FavoriteList.rawValue)
        
        self.viewControllers = controllers
    }
    
    func isAppUpdated() -> Bool {
        let ud = UtilUserDefaults()
        let actualVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let memoryVersion = ud.memoryVersion
//        print("actualVersion = \(actualVersion)")
//        print("memoryVersion = \(memoryVersion)")
        
        let compareResult = memoryVersion.compare(actualVersion, options: .NumericSearch)
//        print("compareResult = \(compareResult.rawValue)")
        if compareResult == .OrderedAscending {
            ud.isAvailableStore = false
            return true
        }
        return false
    }
    
    func checkActualAppVersion() {
        let path = DownloadProfiles.serverUrl + DownloadProfiles.publicProfilesDir + "resources/version.json"
        let reqUrl = NSURL(string: path)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.downloadTaskWithURL(reqUrl!) { (location, response, error) in
            guard let thisResponse = response else { return }
            guard let thisLocation = location else { return }
            
            let helper = AvailableUpdateHelper()
            helper.moveJSONFilesFromURLResponse(thisResponse, location: thisLocation, isCheckVersion: true)
        }
        
        task.resume()
    }
    
    enum TabIndex: Int {
        case AvailableList = 0,
        FavoriteList,
        ProfileList,
        AboutThisApp
        
        func toStoring() -> String {
            return String(self)
        }
        
        func getTitle() -> String {
            return NSLocalizedString(self.toStoring(), comment: "(・∀・)")
        }
    }
}
