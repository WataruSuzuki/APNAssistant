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
