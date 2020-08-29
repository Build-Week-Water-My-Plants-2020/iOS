//
//  MockData.swift
//  WaterMyPlantsTests
//
//  Created by Morgan Smith on 8/29/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

let userData = """
{
    "id" : 1,
    "username" : "Desi",
    "password" : "password",
    "phoneNumber" : "2525551234"
}
""".data(using: .utf8)

let plantData = """
{
    "id" : 1
    "nickName" : "Parker",
    "species" : "Perennial Flowering",
    "h2oFrequency" : "5",
    "image" : "https://5.imimg.com/data5/ZP/WL/CY/SELLER-91354607/spider-plant-jpg-500x500.jpg",
    "dateLastWatered" : "460",
    "notificationTime" : "10:00:00",
    "notificationEnabled" : false,
    "userId" : 1
}
""".data(using: .utf8)
