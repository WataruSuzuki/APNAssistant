//
//  AppDelegate.swift
//  ApnAssister
//
//  Created by 鈴木 航 on 2016/03/18.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let tabbarItemsTitle = [NSLocalizedString("favorite_list", comment: ""),
                            NSLocalizedString("profile_list", comment: ""),
                            "(・∀・)"]
    private var _launchedShortcutItem: AnyObject?
    @available(iOS 9.0, *)
    var launchedShortcutItem: UIApplicationShortcutItem? {
        get {
            return _launchedShortcutItem as? UIApplicationShortcutItem
        }
        set {
            _launchedShortcutItem = newValue
        }
    }
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UtilHandleRLMObject.copyToGroupDB()
        UtilHandleRLMObject.setupGroupDB()
        loadTabBarTitle()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @available(iOS 9.0, *)
    func shouldPerformAdditionalDelegateHandling(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        let shouldPerformAdditionalDelegateHandling: Bool
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = false
        } else {
            shouldPerformAdditionalDelegateHandling = true
        }
        /*
         // Install initial versions of our two extra dynamic shortcuts.
         if let shortcutItems = application.shortcutItems where shortcutItems.isEmpty {
         // Construct the items.
         let shortcut3 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Third.type, localizedTitle: "Play", localizedSubtitle: "Will Play an item", icon: UIApplicationShortcutIcon(type: .Play), userInfo: [
         AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Play.rawValue
         ]
         )
         
         let shortcut4 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Fourth.type, localizedTitle: "Pause", localizedSubtitle: "Will Pause an item", icon: UIApplicationShortcutIcon(type: .Pause), userInfo: [
         AppDelegate.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Pause.rawValue
         ]
         )
         
         // Update the application providing the initial 'dynamic' shortcut items.
         application.shortcutItems = [shortcut3, shortcut4]
         }*/
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    enum ShortcutIdentifier: String {
        case First
        //case Second
        //case Third
        //case Fourth
        
        // MARK: Initializers
        
        init?(fullType: String) {
            guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        // MARK: Properties
        
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    func loadTabBarTitle() {
        if let tabbarController = self.window?.rootViewController as? UITabBarController {
            var index = 0
            for item in tabbarController.tabBar.items! {
                item.title = tabbarItemsTitle[index]
                index += 1
            }
        }
    }
}

