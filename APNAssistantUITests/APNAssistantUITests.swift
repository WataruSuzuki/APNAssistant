//
//  APNAssistantUITests.swift
//  APNAssistantUITests
//
//  Created by WataruSuzuki on 2016/03/18.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import XCTest

class APNAssistantUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            createAPN(app: app)
        }
    }
    
    @available(iOS 9.0, *)
    func createAPN(app: XCUIApplication) {
        
        app.sheets[getTestStr(key: "confirm")].buttons[getTestStr(key: "cancel")].tap()
        app.tabBars.buttons[getTestStr(key: "profileList")].tap()
        app.navigationBars[getTestStr(key: "profileList")].buttons[(isJapanese() ? "追加" : "Add")].tap()
        
        let tablesQuery = app.tables
        let textField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        textField.typeText("APN Assistant UI Tests")
        
        let app2 = app
        app2.tables.staticTexts[getTestStr(key: "keyAttachApnName")].tap()
        
        let nextButton = app2.buttons["Next:"]
        nextButton.tap()
        
        let apnCellsQuery = tablesQuery.cells.containing(.staticText, identifier:getTestStr(key: "keyAttachApnName"))
        apnCellsQuery.textFields[getTestStr(key: "no_settings")].typeText("\n")
        
        let textField2 = apnCellsQuery.children(matching: .textField).element
        textField2.typeText("apnassistant")
        let moreKey = app.keys["more"]
        moreKey.tap()
        moreKey.tap()
        textField2.typeText(".")
        moreKey.tap()
        moreKey.tap()
        textField2.typeText("com")
        nextButton.tap()
        textField2.typeText("\n")
        app.navigationBars[getTestStr(key: "edit_apn")].buttons[(isJapanese() ? "保存" : "Save")].tap()
        app.sheets[getTestStr(key: "is_update_now")].buttons[getTestStr(key: "not_this_time")].tap()
    }
    
    func getTestStr(key: String) -> String {
        let str = NSLocalizedString(key, bundle: Bundle(for: APNAssistantUITests.self), comment: "")
        return str
    }
    
    func isJapanese() -> Bool {
        return getTestStr(key: "error") == "エラー"
    }
}
