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
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.appDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        loadTabBarTitle()
        appStatus.checkAccountAuth()
        
        hiddenSomeTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !appStatus.isAvailableAllFunction() {
            appStatus.startCheckActualAppVersion()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appDidBecomeActive(_ notification: Notification) {
        if #available(iOS 9.0, *) {
            executeShortcutActions()
        }
    }
    
    @available(iOS 9.0, *)
    func executeShortcutActions() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            guard let shortcutItem = delegate.myUtilShortcutLaunch.launchedShortcutItem else {
                return
            }
            switch shortcutItem.type {
            case UtilShortcutLaunch.ShortcutIdentifier.first.type:
                self.selectedViewController = self.viewControllers![MainTabBarController.TabIndex.favoriteList.rawValue] as! UINavigationController
                
            default:
                execureShortcutUpdateApn(shortcutItem.type)
                break
            }
            delegate.myUtilShortcutLaunch.launchedShortcutItem = nil
        }
    }
    
    func execureShortcutUpdateApn(_ type: String) {
        guard appStatus.isAvailableAllFunction() else {
            appStatus.showStatuLimitByApple(self)
            return
        }
        
        let results = ApnSummaryObject.getFavoriteLists()
        let shortcut = UtilShortcutLaunch.ShortcutIdentifier(fullType: type)
        let shortcutApn = results.objects(with: NSPredicate(format: "id = %d", shortcut!.rawValue)).lastObject() as! ApnSummaryObject
        
        let shortcutApnObj = UtilHandleRLMObject(id: shortcutApn.id, profileObj: shortcutApn.apnProfile, summaryObj: shortcutApn)
        let url = self.myUtilCocoaHTTPServer.prepareOpenSettingAppToSetProfile(shortcutApnObj)
        UIApplication.shared.openURL(url)
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
            controllers?.remove(at: TabIndex.availableList.rawValue)
        #elseif IS_APN_BOOKMARKS
            controllers?.remove(at: TabIndex.profileList.rawValue)
            controllers?.remove(at: TabIndex.favoriteList.rawValue)
        #else
            //do nothing
            return
        #endif
        
        self.viewControllers = controllers
        
        /*
         なぜかwindow.tintColorでは変更ができず、UIView.appearanceをいじると
         tabが全てアクティブになるので、ここで初期化する
         */
        
        let selected = self.selectedIndex
        for item in self.viewControllers! {
            self.selectedViewController = item
        }
        
        self.selectedViewController = self.viewControllers![selected]
    }
    
    func setupTintColor() {
        #if IS_APN_MEMO
            UIView.appearance().tintColor = nil
        #elseif IS_APN_BOOKMARKS
            UIView.appearance().tintColor = UIColor.black
        #else
            //Use Storyboard defined.
        #endif
    }
    
    enum TabIndex: Int {
        case availableList = 0,
        favoriteList,
        profileList,
        aboutThisApp
        
        func toString() -> String {
            return String(describing: self)
        }
        
        func getTitle() -> String {
            return NSLocalizedString(self.toString(), comment: "(・∀・)")
        }
    }
}
