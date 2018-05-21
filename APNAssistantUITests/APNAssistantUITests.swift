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
            createFullAPN(app: app)
        }
    }

    @available(iOS 9.0, *)
    private func createFullAPN(app: XCUIApplication) {
        cancelAvailableList(app)
        tapAddNewProfile(app)

        let tablesQuery = app.tables
        let summaryTextField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        summaryTextField.typeText("Full APN Tests")

        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        
        app.tables.staticTexts[UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self)].tap()
        let apnCellsQuery = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self))
        
        let apnNameTextField = apnCellsQuery.children(matching: .textField).element
        apnNameTextField.tap()
        apnNameTextField.typeText("full.apnassistant.com")
        
        let setDataApnManuallySwitch = tablesQuery/*@START_MENU_TOKEN@*/.switches[UITestUtils.getTestStr(key: "setDataApnManual", sender: APNAssistantUITests.self)]/*[[".cells.switches[\"Set Data Apn manually\"]",".switches[\"Set Data Apn manually\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        setDataApnManuallySwitch/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 1.4);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self)]/*[[".cells.staticTexts[\"Default apn name\"]",".staticTexts[\"Default apn name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.swipeUp()
        
        let dataApnNameCellsQuery = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyApnsName", sender: APNAssistantUITests.self))
        let dataApnNameTextField = dataApnNameCellsQuery.children(matching: .textField).element
        dataApnNameTextField.tap()
        dataApnNameTextField.typeText("full.data.apn.com")
        
        let dataApnUserNameCellsQuery = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyApnsUsername", sender: APNAssistantUITests.self))
        let dataApnUserNameTextField = dataApnUserNameCellsQuery.children(matching: .textField).element
        dataApnUserNameTextField.tap()
        dataApnUserNameTextField.typeText("username")
        
//        let dataApnPasswordCellsQuery = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyApnsPassword", sender: APNAssistantUITests.self))
//        let dataApnPasswordTextField = dataApnPasswordCellsQuery.children(matching: .textField).element
//        dataApnPasswordTextField.tap()
//        dataApnPasswordTextField.typeText("password")
        
        tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyApnsAllowedProtocolMask", sender: APNAssistantUITests.self)).textFields["nothing"].tap()
        
//        let nothingPickerWheel = tablesQuery/*@START_MENU_TOKEN@*/.pickerWheels["nothing"]/*[[".cells",".pickers.pickerWheels[\"nothing\"]",".pickerWheels[\"nothing\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//        nothingPickerWheel.swipeUp()
//        nothingPickerWheel.swipeUp()
//        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[UITestUtils.getTestStr(key: "keyApnsAllowedProtocolMask", sender: APNAssistantUITests.self)]/*[[".cells.staticTexts[\"Data apn protocol\"]",".staticTexts[\"Data apn protocol\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        saveNewProfile(app)
    }

    @available(iOS 9.0, *)
    private func createSimpleAPN(app: XCUIApplication) {
        cancelAvailableList(app)
        tapAddNewProfile(app)
        
        let tablesQuery = app.tables
        let textField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        textField.typeText("Simple APN Tests")
        
        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        
        app.tables.staticTexts[UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self)].tap()
        let apnCellsQuery = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self))
        
        let textField2 = apnCellsQuery.children(matching: .textField).element
        textField2.tap()
        textField2.typeText("simple.apnassistant.com")
        
        saveNewProfile(app)
    }
    
    @available(iOS 9.0, *)
    fileprivate func cancelAvailableList(_ app: XCUIApplication) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIApplication().tap()
        } else {
            app.sheets[UITestUtils.getTestStr(key: "confirm", sender: APNAssistantUITests.self)].buttons[UITestUtils.getTestStr(key: "cancel", sender: APNAssistantUITests.self)].tap()
        }
    }
    
    @available(iOS 9.0, *)
    fileprivate func saveNewProfile(_ app: XCUIApplication) {
        app.navigationBars[UITestUtils.getTestStr(key: "edit_apn", sender: APNAssistantUITests.self)].buttons[(UITestUtils.isJapanese(sender: APNAssistantUITests.self) ? "保存" : "Save")].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIApplication()/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        } else {
            app.sheets[UITestUtils.getTestStr(key: "is_update_now", sender: APNAssistantUITests.self)].buttons[UITestUtils.getTestStr(key: "not_this_time", sender: APNAssistantUITests.self)].tap()
        }
    }

    @available(iOS 9.0, *)
    fileprivate func tapAddNewProfile(_ app: XCUIApplication) {
        app.tabBars.buttons[UITestUtils.getTestStr(key: "profileList", sender: APNAssistantUITests.self)].tap()
        app.navigationBars[UITestUtils.getTestStr(key: "profileList", sender: APNAssistantUITests.self)].buttons[(UITestUtils.isJapanese(sender: APNAssistantUITests.self) ? "追加" : "Add")].tap()
    }
}
