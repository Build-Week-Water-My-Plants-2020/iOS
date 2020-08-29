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


    func testSegueToAddNewPlant() {
        let app = launch()
        let itemButton = app.navigationBars["Plant Parenthood"].children(matching: .button).matching(identifier: "Item").element(boundBy: 1)
        itemButton.tap()
        XCTAssertEqual(app.navigationBars.staticTexts.firstMatch.label, "Add New Plant")
    }
    

}
