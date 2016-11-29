//
//  APNAssistantUITests.swift
//  APNAssistantUITests
//
//  Created by WataruSuzuki on 2016/03/18.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import XCTest

class ApnAssisterUITests: XCTestCase {
        
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
            createAPNProfile(app: app)
        }
    }
    
    @available(iOS 9.0, *)
    func createAPNProfile(app: XCUIApplication) {
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        
        app.sheets["確認"].buttons["キャンセル"].tap()
        app.tabBars.buttons["プロファイル"].tap()
        app.navigationBars["プロファイル"].buttons["追加"].tap()
        
        let key = app.keyboards.keys["その他、文字"]
        key.tap()
        key.tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("watarup")
        
        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        
        let app2 = app
        app2.buttons["Next:"].tap()
        
        let apnCellsQuery = tablesQuery.cells.containing(.staticText, identifier:"デフォルトAPNの名前")
        apnCellsQuery.textFields["未設定"].typeText("\n")
        key.tap()
        key.tap()
        
        let textField = apnCellsQuery.children(matching: .textField).element
        textField.typeText("watargu")
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        textField.typeText("ar")
        app2.keys["T U V "].swipeLeft()
        textField.typeText("u.")
        deleteKey.tap()
        deleteKey.tap()
        nextButton.tap()
        textField.typeText(".")
        app2.keys["A B C "].swipeUp()
        textField.typeText("c")
        app2.buttons[".com"].tap()
        
        let tablesQuery2 = app2.tables
        let apnStaticText = tablesQuery2.staticTexts["デフォルトAPNのユーザ名"]
        apnStaticText.tap()
        apnStaticText.tap()
        apnStaticText.tap()
        apnStaticText.swipeRight()
        apnStaticText.tap()
        tablesQuery2.textFields["未設定"].tap()
        
        let secureTextField = tablesQuery2.secureTextFields["未設定"]
        secureTextField.tap()
        secureTextField.swipeRight()
        
        let apnSwitch = tablesQuery2.switches["データAPNを手動でセットする"]
        apnSwitch.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.swipeUp()
        tablesQuery2.staticTexts["データAPNの名前"].swipeRight()
        apnSwitch.tap()
        apnStaticText.tap()
        app.navigationBars["APN編集"].buttons["保存"].tap()
        app.sheets["今すぐデバイスへ設定しますか?"].buttons["はい, 更新します"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
    }
}
