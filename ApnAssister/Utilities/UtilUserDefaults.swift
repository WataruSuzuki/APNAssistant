//
//  UtilUserDefaults.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilUserDefaults: NSUserDefaults {
    
    let ud = NSUserDefaults.standardUserDefaults()

    private struct Default {
        static let available_appstore = false
    }
    
    var isAvailableStore: Bool {
        get {
            ud.registerDefaults(["available_appstore": Default.available_appstore])
            return ud.boolForKey("available_appstore")
        }
        set(nextValue) {
            ud.setBool(nextValue, forKey: "available_appstore")
            ud.synchronize()
        }
    }
}
