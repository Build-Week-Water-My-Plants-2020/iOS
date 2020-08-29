//
//  WaterMyPlantsTests.swift
//  WaterMyPlantsTests
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import XCTest
@testable import WaterMyPlants

class WaterMyPlantsTests: XCTestCase {

    func testFetchingAllUsers() {
         let expectation = self.expectation(description: "All users should not be empty.")
          let networkController = Networking.sharedNetworkController
        networkController.fetchRegisteredUsers() {_ in
            XCTAssertFalse(networkController.allUsers.isEmpty)
            print("Fulfilling expectation")
            expectation.fulfill()
          }

        print("Waiting for expectation(s)")
        waitForExpectations(timeout: 5)
        print("Done waiting for expectations")
      }

    func testFetchingPlantsFromServer() {
       let expectation = self.expectation(description: "All plants should not be empty.")
        let networkController = Networking.sharedNetworkController
      networkController.fetchPlantsFromServer() {_ in
          XCTAssertFalse(networkController.allPlants.isEmpty)
          print("Fulfilling expectation")
          expectation.fulfill()
        }

      print("Waiting for expectation(s)")
      waitForExpectations(timeout: 10)
      print("Done waiting for expectations")
    }

    func testCreatingUser() {
        let username = "iosTest4"
        let password = "iosTest4Password"
        let phoneNumber = "555-555-555"

        let user = User(id: 1, username: username, password: password, phoneNumber: phoneNumber)
        XCTAssertNotNil(user)
    }

    func testCreatingPlant() {
        let nickName = "Aloe Vera Test"
        let species = "Aloe Test"
        let h2oFrequency = "1"
        let image = "none"
        let dateLastWatered = "Dec 6"
        let notificationTime = "10:00:00"

        let plant = Plant(nickName: nickName, species: species, h2oFrequency: h2oFrequency, image: image, dateLastWatered: dateLastWatered, notificationTime: notificationTime)
        XCTAssertNotNil(plant)
    }


}
