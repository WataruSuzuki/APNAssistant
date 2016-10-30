//
//  UtilUserDefaults.swift
//  ApnAssister
//
//  Created by WataruSuzuki on 2016/09/22.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class UtilUserDefaults: UserDefaults {
    
    let ud = UserDefaults.standard

    fileprivate struct Default {
        static let available_appstore = false
        static let memory_version = "0.0.0"
    }
    
    var isAvailableStore: Bool {
        get {
            ud.register(defaults: ["available_appstore": Default.available_appstore])
            return ud.bool(forKey: "available_appstore")
        }
        set(nextValue) {
            ud.set(nextValue, forKey: "available_appstore")
            ud.synchronize()
        }
    }
    
    var memoryVersion: String {
        get {
            ud.register(defaults: ["memory_version": Default.memory_version])
            return ud.string(forKey: "memory_version")!
        }
        set(nextValue) {
            ud.set(nextValue, forKey:  "memory_version")
            ud.synchronize()
        }
    }
}
