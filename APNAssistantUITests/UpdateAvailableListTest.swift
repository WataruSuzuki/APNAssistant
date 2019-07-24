//
//  UpdateAvailableListTest.swift
//  APNAssistantUITests
//
//  Created by WataruSuzuki on 2017/12/31.
//  Copyright © 2017年 WataruSuzuki. All rights reserved.
//

import XCTest

class UpdateAvailableListTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testUpdateAvailableList() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            let confirmSheet = app.sheets[UITestUtils.getTestStr(key: "confirm", sender: UpdateAvailableListTest.self)]
            confirmSheet.buttons[UITestUtils.getTestStr(key: "yes_update", sender: UpdateAvailableListTest.self)].tap()
            UITestUtils.waitingSec(sec: 20.0, sender: self)
            confirmSheet.buttons[UITestUtils.getTestStr(key: "yes_cache", sender: UpdateAvailableListTest.self)].tap()
            UITestUtils.waitingSec(sec: 20.0, sender: self)
            app.alerts[UITestUtils.getTestStr(key: "complete_cache", sender: UpdateAvailableListTest.self)].buttons["OK"].tap()
        }
    }
    
}
