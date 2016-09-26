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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UtilHandleRLMObject.copyToGroupDB()
        UtilHandleRLMObject.setupGroupDB()
        
        FIROptions.defaultOptions().deepLinkURLScheme = "jchankchanapnabookmarks://"
        FIRApp.configure()
        if #available(iOS 9.0, *) {
            return shouldPerformAdditionalDelegateHandling(application, didFinishLaunchingWithOptions: launchOptions)
        } else {
            return true
        }
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
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return application(app, openURL: url, sourceApplication: nil, annotation: [:])
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLinkFromCustomSchemeURL(url) {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            print(dynamicLink)
            return true
        }
        
        return false
    }
    
    @available(iOS 8.0, *)
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let handled = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
        }
        return handled!
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        completionHandler(myUtilShortcutLaunch.handleShortCutItem(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    func shouldPerformAdditionalDelegateHandling(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return myUtilShortcutLaunch.shouldPerformAdditionalDelegateHandling(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}

