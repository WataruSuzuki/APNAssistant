//
//  UITestUtils.swift
//  APNAssistantUITests
//
//  Created by WataruSuzuki on 2018/01/19.
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

    @available(iOS 9.0, *)
    static func cancelAvailableList(_ app: XCUIApplication) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIApplication().tap()
        } else {
            app.sheets[UITestUtils.getTestStr(key: "confirm", sender: CreateAPNTests.self)].buttons[UITestUtils.getTestStr(key: "cancel", sender: CreateAPNTests.self)].tap()
        }
    }
    
    @available(iOS 9.0, *)
    static func saveNewProfile(_ app: XCUIApplication) {
        app.navigationBars[UITestUtils.getTestStr(key: "edit_apn", sender: CreateAPNTests.self)].buttons[(UITestUtils.isJapanese(sender: CreateAPNTests.self) ? "保存" : "Save")].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIApplication()/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        } else {
            app.sheets[UITestUtils.getTestStr(key: "is_update_now", sender: CreateAPNTests.self)].buttons[UITestUtils.getTestStr(key: "not_this_time", sender: CreateAPNTests.self)].tap()
        }
    }

    class func getTestStr(key: String, sender: AnyClass) -> String {
        if let languageBundlePath = Bundle(for: sender).path(forResource: NSLocale.current.languageCode!, ofType: "lproj") {
            if let localizationBundle = Bundle(path: languageBundlePath) {
                return NSLocalizedString(key, bundle:localizationBundle, comment: "")
            }
        }
        return NSLocalizedString(key, bundle:Bundle(for: CreateAPNTests.self), comment: "")
    }
    
    class func isJapanese(sender: AnyClass) -> Bool {
        return getTestStr(key: "error", sender: sender) == "エラー"
    }
}
