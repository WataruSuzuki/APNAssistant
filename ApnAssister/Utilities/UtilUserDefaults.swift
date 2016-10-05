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
        static let signin_success = false
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
    
    var isSignInSuccess: Bool {
        get {
            ud.register(defaults: ["signin_success": Default.signin_success])
            #if false
                return ud.boolForKey("signin_success")
            #else
                return true
            #endif
        }
        set(nextValue) {
            ud.set(nextValue, forKey: "signin_success")
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
