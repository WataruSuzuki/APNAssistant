//
//  CreateAPNTests.swift
//  APNAssistantUITests
//
//  Created by WataruSuzuki on 2016/03/18.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import XCTest

class CreateAPNTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            app.launch()
            UITestUtils.cancelAvailableList(app)
            tapAddNewProfile(app)
        }
    }
    
    fileprivate func tapAddNewProfile(_ app: XCUIApplication) {
        app.tabBars.buttons[UITestUtils.getTestStr(key: "profileList", sender: CreateAPNTests.self)].tap()
        app.navigationBars[UITestUtils.getTestStr(key: "profileList", sender: CreateAPNTests.self)].buttons[(UITestUtils.isJapanese(sender: CreateAPNTests.self) ? "追加" : "Add")].tap()
        
        app.sheets[UITestUtils.getTestStr(key: "caution", sender: CreateAPNTests.self)].buttons[UITestUtils.getTestStr(key: "understand", sender: CreateAPNTests.self)].tap()
    }
    
    private func inputSummary(name: String, tablesQuery: XCUIElementQuery) {
        let summaryTextField: XCUIElement
        if UIDevice.current.userInterfaceIdiom == .pad {
            summaryTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["nameOfThisApnProfile"]/*[[".cells",".textFields[\"Name of This APN profile\"]",".textFields[\"nameOfThisApnProfile\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        } else {
            summaryTextField = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element
        }
        summaryTextField.typeText(name)
    }
    
    private func queryCell(key: String, from: XCUIElementQuery) -> XCUIElementQuery {
        //from.staticTexts[UITestUtils.getTestStr(key: "keyAttachApnName", sender: APNAssistantUITests.self)].tap()
        return from.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: key, sender: CreateAPNTests.self))
    }
    
    private func inputApnElement(info: String, cell: XCUIElementQuery) {
        let textField = cell.children(matching: .textField).element.firstMatch
        textField.tap()
        textField.typeText(info)
    }
    
    private func queryDataApnManuallySwitch(tablesQuery: XCUIElementQuery) -> XCUIElement {
        return tablesQuery.switches[UITestUtils.getTestStr(key: "setDataApnManual", sender: CreateAPNTests.self)]
    }

    private func queryThenInputElement(identifier: String, tablesQuery: XCUIElementQuery, text: String) {
        let cell = tablesQuery.cells.containing(.staticText, identifier:UITestUtils.getTestStr(key: identifier, sender: CreateAPNTests.self))
        
        let textField = cell.children(matching:
            identifier.contains("Password")
                ? .secureTextField
                : .textField)
            .element.firstMatch
        
        textField.tap()
        textField.typeText(text)
    }
    
    func pickElement(identifier: String, tablesQuery: XCUIElementQuery) {
        let cell = tablesQuery.cells.containing(.staticText, identifier: identifier)
        if cell.textFields["nothing"].exists {
            cell.textFields["nothing"].tap()
        } else {
            let editapntableviewTable = XCUIApplication().tables["EditApnTableView"]
            editapntableviewTable.staticTexts[UITestUtils.getTestStr(key: identifier, sender: CreateAPNTests.self)].tap()
        }
        
        switch identifier {
        case "keyApnsAllowedProtocolMaskInDomesticRoaming":
            tablesQuery.pickerWheels["nothing"].adjust(toPickerWheelValue: "both")
        case "keyApnsAllowedProtocolMaskInRoaming":
            tablesQuery.pickerWheels["nothing"].adjust(toPickerWheelValue: "ipv6")
        default:
            tablesQuery.pickerWheels["nothing"].adjust(toPickerWheelValue: "ipv4")
        }
    }

    func testCreateFullAPN() {
        let app = XCUIApplication()

        let tablesQuery = app.tables
        inputSummary(name: "Full APN Tests", tablesQuery: tablesQuery)

        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        
        let apnCellsQuery = queryCell(key: "keyAttachApnName", from: tablesQuery)
        inputApnElement(info: "full.apnassistant.com", cell: apnCellsQuery)
        
        apnCellsQuery.element.swipeDown()

        var setDataApnManuallySwitch = queryDataApnManuallySwitch(tablesQuery: tablesQuery)
        while !setDataApnManuallySwitch.exists {
            apnCellsQuery.element.swipeUp()
            setDataApnManuallySwitch = queryDataApnManuallySwitch(tablesQuery: tablesQuery)
            if setDataApnManuallySwitch.exists {
                break
            }
        }
        setDataApnManuallySwitch/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 1.4);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/

        apnCellsQuery.element.swipeUp()

        queryThenInputElement(identifier: "keyApnsName", tablesQuery: tablesQuery, text: "full.data.apn.com")
        queryThenInputElement(identifier: "keyApnsUsername", tablesQuery: tablesQuery, text: "username")
        queryThenInputElement(identifier: "keyApnsPassword", tablesQuery: tablesQuery, text: "password")
        queryThenInputElement(identifier: "keyApnsProxyServer", tablesQuery: tablesQuery, text: "apnassistant.proxy.com")
        queryThenInputElement(identifier: "keyApnsProxyServerPort", tablesQuery: tablesQuery, text: "8080")

        if #available(iOS 10.3, *) {
            // Hide keyboard
            let dataApnCellsQuery = queryCell(key: "keyApnsProxyServerPort", from: tablesQuery)
            dataApnCellsQuery.element.firstMatch.swipeUp()
            UITestUtils.waitingSec(sec: 2.0, sender: self)
            
            pickElement(identifier: "keyApnsAllowedProtocolMask", tablesQuery: tablesQuery)
            pickElement(identifier: "keyApnsAllowedProtocolMaskInRoaming", tablesQuery: tablesQuery)
            pickElement(identifier: "keyApnsAllowedProtocolMaskInDomesticRoaming", tablesQuery: tablesQuery)
        }

        UITestUtils.saveNewProfile(app)
    }

    func testCreateSimpleAPN() {
        let app = XCUIApplication()
        
        let tablesQuery = app.tables
        inputSummary(name: "Simple APN Tests", tablesQuery: tablesQuery)
        
        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        
        let apnCellsQuery = queryCell(key: "keyAttachApnName", from: tablesQuery)
        inputApnElement(info: "simple.apnassistant.com", cell: apnCellsQuery)
        
        UITestUtils.saveNewProfile(app)
    }
}
