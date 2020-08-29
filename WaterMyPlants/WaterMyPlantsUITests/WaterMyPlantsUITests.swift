//
//  WaterMyPlantsUITests.swift
//  WaterMyPlantsUITests
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import XCTest
//@testable import WaterMyPlants

class WaterMyPlantsUITests: XCTestCase {

    var app = XCUIApplication()

    func launch() -> XCUIApplication {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        return app
    }

    func testSegueFromLogin() {

        app.launch()
        app.buttons["SIGN UP"].tap()

        let NavText = app.navigationBars["Plant Parenthood"].staticTexts["Plant Parenthood"]
        XCTAssertEqual(NavText.label, "Plant Parenthood")
    }

    func testSegueToUser() {
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["SIGN UP"]/*[[".buttons[\"SIGN UP\"].staticTexts[\"SIGN UP\"]",".staticTexts[\"SIGN UP\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Plant Parenthood"].children(matching: .button).matching(identifier: "Item").element(boundBy: 0).tap()
        let userText = app.staticTexts["Username"]
        XCTAssertEqual(userText.label, "Username")
    }

    func testSegueToPlantDetail() {

        app.launch()
        app.buttons["SIGN UP"].tap()
        app.navigationBars["Plant Parenthood"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()

       let plantText = app.navigationBars["Add New Plant"].staticTexts["Add New Plant"]
        XCTAssertEqual(plantText.label, "Add New Plant")
    }

    func testSegueSavingPlant() {

        app.launch()
        app.buttons["SIGN UP"].tap()
        
        let plantParenthoodNavigationBar = app.navigationBars["Plant Parenthood"]
        plantParenthoodNavigationBar.children(matching: .button).matching(identifier: "Item").element(boundBy: 1).tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add Plant"]/*[[".buttons[\"Add Plant\"].staticTexts[\"Add Plant\"]",".staticTexts[\"Add Plant\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let plantTableText = plantParenthoodNavigationBar.staticTexts["Plant Parenthood"]
        XCTAssertEqual(plantTableText.label, "Plant Parenthood")
    }

    func testLoginToggle() {
        app.launch()
        app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["Sign In"]/*[[".segmentedControls.buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
       let loginButton = app/*@START_MENU_TOKEN@*/.buttons.matching(identifier: "Sign In").staticTexts["Sign In"]/*[[".buttons.matching(identifier: \"Sign In\").staticTexts[\"Sign In\"]",".staticTexts[\"Sign In\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        XCTAssertEqual(loginButton.label, "Sign In")
    }

}
