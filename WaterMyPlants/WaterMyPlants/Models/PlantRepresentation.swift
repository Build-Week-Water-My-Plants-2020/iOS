//
//  PlantRepresentation.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/20/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

struct PlantRepresentation: Equatable, Codable {
    var id: Int16?
    var nickname: String
    var species: String?
    var h20Frequency: Int16?
    var userId: Int?
    var avatar: String?
    var lastWateredAt: Date?
}
