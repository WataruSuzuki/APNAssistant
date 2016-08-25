//
//  MainTabBarController.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

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
        executeShortcutActions()
    }
    
    func executeShortcutActions() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if #available(iOS 9.0, *) {
                guard let shortcutItem = delegate.myUtilShortcutLaunch.launchedShortcutItem else {
                    return
                }
                switch shortcutItem.type {
                case UtilShortcutLaunch.ShortcutIdentifier.First.type:
                    self.selectedViewController = self.viewControllers![MainTabBarController.TabIndex.FavoriteList.rawValue] as! UINavigationController
                    
                default:
                    break
                }
                delegate.myUtilShortcutLaunch.launchedShortcutItem = nil
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
    
    enum TabIndex: Int {
        case ProfileList = 0,
        FavoriteList
        
        func toStoring() -> String {
            return String(self)
        }
        
        func getTitle() -> String {
            return NSLocalizedString(self.toStoring(), comment: "(・∀・)")
        }
    }
}
