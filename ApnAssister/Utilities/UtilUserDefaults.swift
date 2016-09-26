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
        static let signin_success = false
        static let memory_version = "0.0.0"
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
    
    var isSignInSuccess: Bool {
        get {
            ud.registerDefaults(["signin_success": Default.signin_success])
            return ud.boolForKey("signin_success")
        }
        set(nextValue) {
            ud.setBool(nextValue, forKey: "signin_success")
            ud.synchronize()
        }
    }
    
    var memoryVersion: String {
        get {
            ud.registerDefaults(["memory_version": Default.memory_version])
            return ud.stringForKey("memory_version")!
        }
        set(nextValue) {
            ud.setObject(nextValue, forKey:  "memory_version")
            ud.synchronize()
        }
    }
}