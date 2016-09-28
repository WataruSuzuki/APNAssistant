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
    let appStatus = UtilAppStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTintColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.appDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        loadTabBarTitle()
        appStatus.checkAccountAuth()
        
        hiddenSomeTabbar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !appStatus.isAvailableAllFunction() {
            appStatus.checkActualAppVersion()
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
        #if IS_APN_MEMO
            controllers?.removeAtIndex(TabIndex.AvailableList.rawValue)
        #elseif IS_APN_BOOKMARKS
            controllers?.removeAtIndex(TabIndex.ProfileList.rawValue)
            controllers?.removeAtIndex(TabIndex.FavoriteList.rawValue)
        #else
            //do nothing
        #endif
        
        self.viewControllers = controllers
    }
    
    func setupTintColor() {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        #if IS_APN_MEMO
            delegate.window!.tintColor = nil
            UIView.appearance().tintColor = nil
        #elseif IS_APN_BOOKMARKS
            delegate.window!.tintColor = UIColor.darkGrayColor()
            UIView.appearance().tintColor = UIColor.darkGrayColor()
        #else
            //Use Storyboard defined.
        #endif
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
