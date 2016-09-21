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
        
        if !UtilUserDefaults().isAvailableStore {
            hiddenSomeTabbar()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UtilUserDefaults().isAvailableStore {
            checkAppVersion()
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
    
    func checkAppVersion() {
        let path = DownloadProfiles.serverUrl + DownloadProfiles.publicProfilesDir + "resources/version.json"
        let reqUrl = NSURL(string: path)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.downloadTaskWithURL(reqUrl!) { (location, response, error) in
            guard let responseUrl = response?.URL else { return }
            guard let lastPathComponent = responseUrl.lastPathComponent else { return }
            
            let fileManager = NSFileManager.defaultManager()
            let filePath = UtilCocoaHTTPServer().getTargetFilePath(lastPathComponent.stringByReplacingOccurrencesOfString(".json", withString: ""), fileType: ".json")
            if fileManager.fileExistsAtPath(filePath) {
                try! fileManager.removeItemAtPath(filePath)
            }
            
            let localUrl = NSURL.fileURLWithPath(filePath)
            do {
                try fileManager.moveItemAtURL(location!, toURL: localUrl)
                if let jsonData = NSData(contentsOfURL: localUrl) {
                    let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! NSDictionary
                    
                    let items = json.objectForKey(DownloadProfiles.profileItems) as! NSArray
                    let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
                    print("currentVersion = \(currentVersion)")

                    for i in 0  ..< items.count  {
                        if "ApnBookmarks" == items[i].objectForKey(DownloadProfiles.profileName) as! NSString {
                            let version = items[i].objectForKey(DownloadProfiles.version) as! NSString
                            print("version = \(version)")
                            if currentVersion == version {
                                UtilUserDefaults().isAvailableStore = true
                            }
                        }
                    }
                }
                
            } catch {
                let nsError = error as NSError
                print(nsError.description)
            }
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
