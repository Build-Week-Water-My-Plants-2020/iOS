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
    var nickname: String
    var species: String?
    var h20Frequencey: Int?
    var userId: Int?
    var avatar: String?
    var lastWateredAt: Date?
}
