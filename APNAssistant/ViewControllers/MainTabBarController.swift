//
//  MainTabBarController.swift
//  APNAssistant
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
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.appDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        loadTabBarTitle()
        
        //hiddenSomeTabbar()
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
    
    @objc func appDidBecomeActive(_ notification: Notification) {
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
        
        if let shortcutApn = results.object(at: UInt(shortcut!.rawValue - 1)) as? ApnSummaryObject {
            let shortcutApnObj = UtilHandleRLMObject(id: shortcutApn.id, profileObj: shortcutApn.apnProfile!, summaryObj: shortcutApn)
            let url = self.myUtilCocoaHTTPServer.prepareOpenSettingAppToSetProfile(shortcutApnObj)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
        controllers?.remove(at: TabIndex.availableList.rawValue)
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
