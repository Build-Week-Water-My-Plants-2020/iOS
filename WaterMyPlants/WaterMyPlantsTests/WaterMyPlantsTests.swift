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

    var userTestRep = UserRepresentation(id: 51, username: "iosUser33", password: "iosUser33", phoneNumber: "")
    var userTestRepBad = UserRepresentation(id: 100, username: "iosUserBad", password: "iosUserBad", phoneNumber: "")

    var userTest = User(id: 51, username: "iosUser33", password: "iosUser33", phoneNumber: "")
    var userToRegister = UserRepresentation(username: "iOSTestRegister", password: "iOSTestRegister", phoneNumber: "")

    func testFetchingAllUsers() {
         let expectation = self.expectation(description: "All users should not be empty.")
          let networkController = Networking.sharedNetworkController
        networkController.fetchRegisteredUsers() {_ in
            XCTAssertFalse(networkController.allUsers.isEmpty)
            print("Fulfilling expectation")
            expectation.fulfill()
          }

        print("Waiting for expectation(s)")
        waitForExpectations(timeout: 10)
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

    func testCreatingUserRepresentation() {
        let username = "iosTest6"
        let password = "iosTest6Password"
        let phoneNumber = "666-666-666"

        let userRep = UserRepresentation(username: username, password: password, phoneNumber: phoneNumber)
        XCTAssertNotNil(userRep)
    }

    func testCreatingPlantRepresentation() {
        let nickName = "Aloe Vera Test 2"
        let species = "Aloe Test 2"
        let h2oFrequency = "2"
        let image = "none 2"
        let dateLastWatered = "Dec 7"
        let notificationTime = "10:30:00"

        let plantRep = PlantRepresentation(nickName: nickName, species: species, h2oFrequency: h2oFrequency, image: image, dateLastWatered: dateLastWatered, notificationEnabled: false, notificationTime: notificationTime, userId: 10)
        XCTAssertNotNil(plantRep)
    }

    func testFetchingUserFromCoreData() {
        let expectation = self.expectation(description: "currentCDUser should not be nill")
          let networkController = Networking.sharedNetworkController
        networkController.fetchUserCD(with: userTestRep)
        XCTAssertFalse(networkController.currentCDUser == nil)
            print("Fulfilling expectation")
            expectation.fulfill()

        print("Waiting for expectation(s)")
        waitForExpectations(timeout: 10)
        print("Done waiting for expectations")
    }

    func testFetchingUserFromCoreDataWithBadData() {
        let expectation = self.expectation(description: "currentCDUser should be nil")
        let networkController = Networking.sharedNetworkController
        userTestRepBad.username = userTestRepBad.username + "1"
        networkController.fetchUserCD(with: userTestRepBad)
        XCTAssertFalse(networkController.currentCDUser != nil)
            print("Fulfilling expectation")
            expectation.fulfill()

        print("Waiting for expectation(s)")
        waitForExpectations(timeout: 10)
        print("Done waiting for expectations")
    }

    func testRegisterUser() {
        let expectation = self.expectation(description: "Test user should not be nil.")
        let networkController = Networking.sharedNetworkController
        userToRegister.username = userToRegister.username + "1"
        networkController.registerUser(with: userToRegister) {_ in
            XCTAssertFalse(networkController.testUser == nil)
            print("Fulfilling expectation")
            expectation.fulfill()
        }

        print("Waiting for expectation(s)")
        waitForExpectations(timeout: 20)
        print("Done waiting for expectations")
    }
    
}
