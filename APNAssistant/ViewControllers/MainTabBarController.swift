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
        setupTintColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.appDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        loadTabBarTitle()
        
        hiddenSomeTabbar()
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
        let results = ApnSummaryObject.getFavoriteLists()
        let shortcut = UtilShortcutLaunch.ShortcutIdentifier(fullType: type)
        
        if let shortcutApn = results.object(at: UInt(shortcut!.rawValue - 1)) as? ApnSummaryObject {
        //if let shortcutApn = results.objects(with: NSPredicate(format: "id = %d", shortcut!.rawValue)).lastObject() as? ApnSummaryObject {
            let shortcutApnObj = UtilHandleRLMObject(id: shortcutApn.id, profileObj: shortcutApn.apnProfile, summaryObj: shortcutApn)
            let url = self.myUtilCocoaHTTPServer.prepareOpenSettingAppToSetProfile(shortcutApnObj)
            UIApplication.shared.openURL(url)
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
        #if FULL_VERSION
            //do nothing
        #else
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
        #endif
    }
    
    func setupTintColor() {
        #if STAND_ALONE_VERSION
            UIView.appearance().tintColor = nil
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
