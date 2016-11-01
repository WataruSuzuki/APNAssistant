//
//  UtilShortcutLaunch.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilShortcutLaunch: NSObject {

    fileprivate var _launchedShortcutItem: Any?
    @available(iOS 9.0, *)
    var launchedShortcutItem: UIApplicationShortcutItem? {
        get {
            return _launchedShortcutItem as? UIApplicationShortcutItem
        }
        set {
            _launchedShortcutItem = newValue
        }
    }
    
    static let infoKey = "AppShortcutUserInfoIconKey"
    
    @available(iOS 9.0, *)
    func shouldPerformAdditionalDelegateHandling(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        #if FULL_VERSION
            // Install initial versions of our two extra dynamic shortcuts.
            initDynamicShortcuts(application)
            
            // If a shortcut was launched, display its information and take the appropriate action
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
                
                launchedShortcutItem = shortcutItem
                
                // This will block "performActionForShortcutItem:completionHandler" from being called.
                return false
            }
        #endif//FULL_VERSION
        return true
    }
    
    @available(iOS 9.0, *)
    func initDynamicShortcuts(_ application: UIApplication) {
        #if FULL_VERSION
            var loadedItems = [UIApplicationShortcutItem]()
            let favorites = ApnSummaryObject.getFavoriteLists()
            
            for index in 0...ShortcutIdentifier.fourth.rawValue {
                let shortcut = loadApplicationShortcutItem(index, results: favorites)
                // Update the application providing the initial 'dynamic' shortcut items.
                loadedItems.append(shortcut)
            }
            application.shortcutItems = loadedItems
        #endif//FULL_VERSION
    }
    
    @available(iOS 9.0, *)
    func loadApplicationShortcutItem(_ index: Int, results: RLMResults<RLMObject>) -> UIMutableApplicationShortcutItem {
        let shortcut = ShortcutIdentifier(rawValue: index)
        let name: String?
        let infoKey: Int?
        if index != ShortcutIdentifier.first.rawValue
            && results.count > UInt(index - 1)
        {
            let apnSummary = results.object(at: UInt(index - 1)) as? ApnSummaryObject
            name = apnSummary?.name
            infoKey = apnSummary?.id
        } else {
            name = ""
            infoKey = -1
        }
        return UIMutableApplicationShortcutItem(type: shortcut!.type, localizedTitle: shortcut!.getTitle(name!), localizedSubtitle: shortcut!.getSubTitle(), icon: shortcut!.getIcon(), userInfo: [UtilShortcutLaunch.infoKey: infoKey!])
    }
    
    @available(iOS 9.0, *)
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        launchedShortcutItem = shortcutItem
        switch (shortCutType) {
        case ShortcutIdentifier.first.type: fallthrough
        case ShortcutIdentifier.second.type:fallthrough
        case ShortcutIdentifier.third.type: fallthrough
        case ShortcutIdentifier.fourth.type:
            return true
        default:
            return false
        }
    }
    
    enum ShortcutIdentifier: Int {
        case first = 0,
        second,
        third,
        fourth
        
        // MARK: Initializers
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            switch last {
            case ShortcutIdentifier.first.toString():
                self = .first
            case ShortcutIdentifier.second.toString():
                self = .second
            case ShortcutIdentifier.third.toString():
                self = .third
            case ShortcutIdentifier.fourth.toString():
                self = .fourth
            default:
                return nil
            }
        }
        
        // MARK: Properties
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.toString())"
        }
        
        func toString() -> String {
            return String(describing: self)
        }
        
        func getTitle(_ fallbackTitle: String) -> String {
            if self == ShortcutIdentifier.first {
                return NSLocalizedString("show_favorites", comment: "")
            } else {
                return fallbackTitle
            }
        }
        
        func getSubTitle() -> String {
            if self == ShortcutIdentifier.first {
                return ""
            } else {
                return NSLocalizedString("setThisApnToDevice", comment: "")
            }
        }
        
        @available(iOS 9.1, *)
        func getSystemIcon() -> UIApplicationShortcutIcon {
            if self == ShortcutIdentifier.first {
                return UIApplicationShortcutIcon(type: .love)
            } else {
                return UIApplicationShortcutIcon(type: .update)
            }
        }
        
        @available(iOS 9.0, *)
        func getIcon() -> UIApplicationShortcutIcon {
            if #available(iOS 9.1, *) {
                return getSystemIcon()
            }
            if self == ShortcutIdentifier.first {
                return UIApplicationShortcutIcon(templateImageName: "ic_favorite_shortcut")
            } else {
                return UIApplicationShortcutIcon(templateImageName: "ic_list_shortcut")
            }
        }
    }
    
}
