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
    let myUtilShortcutLaunch = UtilShortcutLaunch()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UtilHandleRLMObject.copyToGroupDB()
        UtilHandleRLMObject.setupGroupDB()
        
        #if FULL_VERSION
            FIROptions.default().deepLinkURLScheme = "jchankchanapnassistant://"
            FIRApp.configure()
        #endif
        if #available(iOS 9.0, *) {
            return shouldPerformAdditionalDelegateHandling(application, didFinishLaunchingWithOptions: launchOptions)
        } else {
            return true
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url, sourceApplication: nil, annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        #if FULL_VERSION
            if let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
                // Handle the deep link. For example, show the deep-linked content or
                // apply a promotional offer to the user's account.
                // ...
                print(dynamicLink)
                return true
            }
        #endif
        
        return false
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        #if FULL_VERSION
            let handled = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
                // ...
            }
            return handled!
        #else
            return false
        #endif
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(myUtilShortcutLaunch.handleShortCutItem(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    func shouldPerformAdditionalDelegateHandling(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        return myUtilShortcutLaunch.shouldPerformAdditionalDelegateHandling(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}

