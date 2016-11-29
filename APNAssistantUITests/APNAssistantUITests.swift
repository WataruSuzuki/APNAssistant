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
        app.sheets["確認"].buttons["キャンセル"].tap()
        app.tabBars.buttons["プロファイル"].tap()
        app.navigationBars["プロファイル"].buttons["追加"].tap()
        
        let tablesQuery = app.tables
        let textField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        textField.typeText("APN Assistant UI Tests")
        
        let app2 = app
        app2.tables.staticTexts["デフォルトAPNの名前"].tap()
        
        let nextButton = app2.buttons["Next:"]
        nextButton.tap()
        
        let apnCellsQuery = tablesQuery.cells.containing(.staticText, identifier:"デフォルトAPNの名前")
        apnCellsQuery.textFields["未設定"].typeText("\n")
        
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
        app.navigationBars["APN編集"].buttons["保存"].tap()
        app.sheets["今すぐデバイスへ設定しますか?"].buttons["今はしない"].tap()
    }
}
