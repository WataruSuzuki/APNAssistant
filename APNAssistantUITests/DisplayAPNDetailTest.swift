//
//  DisplayAPNDetailTest.swift
//  APNAssistantUITests
//
//  Created by 鈴木 航 on 2019/10/22.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import XCTest

class DisplayAPNDetailTest: XCTestCase {

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            app.launch()
            UITestUtils.cancelAvailableList(app)
            app.tabBars.buttons[UITestUtils.getTestStr(key: "profileList", sender: CreateAPNTests.self)].tap()
        }
    }

    func testShowSimpleAPNDetail() {
        let app = XCUIApplication()
        
        app.tables.children(matching: .cell).element.staticTexts["Simple APN Tests"].firstMatch.tap()
        //app.tables.children(matching: .cell).element(boundBy: 3).staticTexts["Simple APN Tests"].tap()
        app.navigationBars["Simple APN Tests"].buttons["Menu"].tap()
//        app.sheets["Menu"].buttons["Edit"].tap()
//        app.tables["EditApnTableView"]/*@START_MENU_TOKEN@*/.staticTexts["Default apn name"]/*[[".cells.staticTexts[\"Default apn name\"]",".staticTexts[\"Default apn name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
//        
//        let editapntableviewTable = XCUIApplication().tables["EditApnTableView"]
//        editapntableviewTable.staticTexts["Data apn protocol"].tap()
    }

}
