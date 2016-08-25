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
    
    static let iconKey = "AppShortcutUserInfoIconKey"
    
    @available(iOS 9.0, *)
    func shouldPerformAdditionalDelegateHandling(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Install initial versions of our two extra dynamic shortcuts.
        initDynamicShortcuts(application, didFinishLaunchingWithOptions: launchOptions)
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            return false
        }
        return true
    }
    
    @available(iOS 9.0, *)
    func initDynamicShortcuts(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        var loadedItems = [UIApplicationShortcutItem]()
        for index in 0...ShortcutIdentifier.Fourth.rawValue {
            let shortcut = loadApplicationShortcutItem(index)
            // Update the application providing the initial 'dynamic' shortcut items.
            loadedItems.append(shortcut)
        }
        application.shortcutItems = loadedItems
    }
    
    @available(iOS 9.0, *)
    func loadApplicationShortcutItem(index: Int) -> UIMutableApplicationShortcutItem {
        let shortcut = ShortcutIdentifier(rawValue: index)
        return UIMutableApplicationShortcutItem(type: shortcut!.type, localizedTitle: shortcut!.getTitle(), localizedSubtitle: shortcut!.getSubTitle(), icon: shortcut!.getIcon(), userInfo: [UtilShortcutLaunch.iconKey: shortcut!.type])
    }
    
    @available(iOS 9.0, *)
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        launchedShortcutItem = shortcutItem
        switch (shortCutType) {
        case ShortcutIdentifier.First.type: fallthrough
        case ShortcutIdentifier.Second.type:fallthrough
        case ShortcutIdentifier.Third.type: fallthrough
        case ShortcutIdentifier.Fourth.type:
            return true
        default:
            return false
        }
    }
    
    enum ShortcutIdentifier: Int {
        case First = 0,
        Second,
        Third,
        Fourth
        
        // MARK: Initializers
        init?(fullType: String) {
            guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
            
            switch last {
            case ShortcutIdentifier.First.toString():
                self = .First
            case ShortcutIdentifier.Second.toString():
                self = .Second
            case ShortcutIdentifier.Third.toString():
                self = .Third
            case ShortcutIdentifier.Fourth.toString():
                self = .Fourth
            default:
                return nil
            }
        }
        
        // MARK: Properties
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.toString())"
        }
        
        func toString() -> String {
            return String(self)
        }
        
        func getTitle() -> String {
            if self == ShortcutIdentifier.First {
                return NSLocalizedString("show_favorites", comment: "")
            } else {
                return "Set this APN"
            }
        }
        
        func getSubTitle() -> String {
            if self == ShortcutIdentifier.First {
                return ""
            } else {
                return NSLocalizedString("setThisApnToDevice", comment: "")
            }
        }
        
        @available(iOS 9.0, *)
        func getIcon() -> UIApplicationShortcutIcon {
            if self == ShortcutIdentifier.First {
                return UIApplicationShortcutIcon(templateImageName: "ic_favorite_shortcut")
            } else {
                return UIApplicationShortcutIcon(templateImageName: "ic_list_shortcut")
            }
        }
    }
    
}
