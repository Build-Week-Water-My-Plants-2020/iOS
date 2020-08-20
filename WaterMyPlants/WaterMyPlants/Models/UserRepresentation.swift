//
//  UserRepresentation.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/20/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var id: Int?
    var username: String
    var password: String
    var phone: String?
    var avatar: String?
    var bearer: String?
}
