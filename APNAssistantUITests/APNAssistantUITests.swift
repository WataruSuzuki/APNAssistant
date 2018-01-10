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
    
    func testCreateAPN() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            createSimpleAPN(app: app)
        }
    }
    
    @available(iOS 9.0, *)
    private func createSimpleAPN(app: XCUIApplication) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIApplication()/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        } else {
            app.sheets[UITestUtils.getTestStr(key: "confirm", sender: APNAssistantUITests.self)].buttons[UITestUtils.getTestStr(key: "cancel", sender: APNAssistantUITests.self)].tap()
        }
        app.tabBars.buttons[UITestUtils.getTestStr(key: "profileList", sender: APNAssistantUITests.self)].tap()
        app.navigationBars[UITestUtils.getTestStr(key: "profileList", sender: APNAssistantUITests.self)].buttons[(UITestUtils.isJapanese(sender: APNAssistantUITests.self) ? "追加" : "Add")].tap()
        
        let tablesQuery = app.tables
        let textField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        textField.typeText("Simple UI Tests")
        
        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        
        app.tables.staticTexts[UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self)].tap()
        let apnCellsQuery = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self))
        
        let textField2 = apnCellsQuery.children(matching: .textField).element
        textField2.tap()
        textField2.typeText("simple.apnassistant.com")
        
        app.navigationBars[UITestUtils.getTestStr(key: "edit_apn", sender: APNAssistantUITests.self)].buttons[(UITestUtils.isJapanese(sender: APNAssistantUITests.self) ? "保存" : "Save")].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIApplication()/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        } else {
            app.sheets[UITestUtils.getTestStr(key: "is_update_now", sender: APNAssistantUITests.self)].buttons[UITestUtils.getTestStr(key: "not_this_time", sender: APNAssistantUITests.self)].tap()
        }
    }
    
    
    
}
