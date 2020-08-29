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




}
