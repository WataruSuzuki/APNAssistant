//
//  UtilShortcutLaunch.swift
//  APNAssistant
//
//  Created by WataruSuzuki on 2016/08/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit
import Realm

class UtilShortcutLaunch: NSObject {
    static let infoKey = "AppShortcutUserInfoIconKey"

    var launchedShortcutItem: UIApplicationShortcutItem?
    
    func shouldPerformAdditionalDelegateHandling(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        // Install initial versions of our two extra dynamic shortcuts.
        initDynamicShortcuts(application)
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            return false
        }
        return true
    }
    
    func initDynamicShortcuts(_ application: UIApplication) {
        var loadedItems = [UIApplicationShortcutItem]()
        let favorites = ApnSummaryObject.getFavoriteLists()
        
        for index in 0...ShortcutIdentifier.fourth.rawValue {
            let shortcut = loadApplicationShortcutItem(index, results: favorites)
            // Update the application providing the initial 'dynamic' shortcut items.
            loadedItems.append(shortcut)
        }
        application.shortcutItems = loadedItems
    }
    
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
        return UIMutableApplicationShortcutItem(type: shortcut!.type, localizedTitle: shortcut!.getTitle(name!), localizedSubtitle: shortcut!.getSubTitle(), icon: shortcut!.getIcon(), userInfo: [UtilShortcutLaunch.infoKey: infoKey! as NSSecureCoding])
    }
    
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
        
        func getIcon() -> UIApplicationShortcutIcon {
            if self == ShortcutIdentifier.first {
                return UIApplicationShortcutIcon(type: .love)
            } else {
                return UIApplicationShortcutIcon(type: .update)
            }
        }
    }
    
}
