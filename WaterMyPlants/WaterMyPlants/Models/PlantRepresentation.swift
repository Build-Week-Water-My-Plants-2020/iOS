//
//  PlantRepresentation.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/20/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

struct PlantRepresentation: Equatable, Codable {
    var id: Int?
    var nickName: String
    var species: String
    var h2oFrequency: String
    var image: String
    var dateLastWatered: String
    var notificationEnabled: Bool
    var notificationTime: String
    var userId: Int?
}
