//
//  UITestUtils.swift
//  APNAssistantUITests
//
//  Created by 鈴木航 on 2018/01/19.
//  Copyright © 2018年 WataruSuzuki. All rights reserved.
//

import XCTest

class UITestUtils: NSObject {
    
    class func waitingSec(sec: Double, sender: XCTestCase) {
        let expectation = sender.expectation(description: "Waiting")
        DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
            expectation.fulfill()
        }
        sender.waitForExpectations(timeout: (TimeInterval(sec + 2))) { (error) in
            //do nothing
        }
    }

    class func getTestStr(key: String, sender: AnyClass) -> String {
        if let languageBundlePath = Bundle(for: sender).path(forResource: NSLocale.current.languageCode!, ofType: "lproj") {
            if let localizationBundle = Bundle(path: languageBundlePath) {
                return NSLocalizedString(key, bundle:localizationBundle, comment: "")
            }
        }
        return NSLocalizedString(key, bundle:Bundle(for: APNAssistantUITests.self), comment: "")
    }
    
    class func isJapanese(sender: AnyClass) -> Bool {
        return getTestStr(key: "error", sender: sender) == "エラー"
    }
}
