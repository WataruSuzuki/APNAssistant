//
//  UtilShortcutLaunch.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilShortcutLaunch: NSObject {

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
    
    @available(iOS 9.0, *)
    func performAdditionalDelegateHandling(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
        
        // Install initial versions of our two extra dynamic shortcuts.
        if let shortcutItems = application.shortcutItems where shortcutItems.isEmpty {
            // Construct the items.
            let shortcut3 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Third.type, localizedTitle: "Play", localizedSubtitle: "Will Play an item", icon: UIApplicationShortcutIcon(type: .Play), userInfo: [
                UtilShortcutLaunch.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Play.rawValue
                ]
            )
            
            let shortcut4 = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.Fourth.type, localizedTitle: "Pause", localizedSubtitle: "Will Pause an item", icon: UIApplicationShortcutIcon(type: .Pause), userInfo: [
                UtilShortcutLaunch.applicationShortcutUserInfoIconKey: UIApplicationShortcutIconType.Pause.rawValue
                ]
            )
            
            // Update the application providing the initial 'dynamic' shortcut items.
            application.shortcutItems = [shortcut3, shortcut4]
        }
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    @available(iOS 9.0, *)
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        launchedShortcutItem = shortcutItem
        switch (shortCutType) {
        case ShortcutIdentifier.First.type:
            // Handle shortcut 1 (static).
            return true
            
        case ShortcutIdentifier.Second.type:
            // Handle shortcut 2 (static).
            handled = true
            break
        case ShortcutIdentifier.Third.type:
            // Handle shortcut 3 (dynamic).
            handled = true
            break
        case ShortcutIdentifier.Fourth.type:
            // Handle shortcut 4 (dynamic).
            handled = true
            break
        default:
            return false
        }
        
        return handled
    }
    
    enum ShortcutIdentifier: String {
        case First
        case Second
        case Third
        case Fourth
        
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
    
}
