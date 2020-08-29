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

}
