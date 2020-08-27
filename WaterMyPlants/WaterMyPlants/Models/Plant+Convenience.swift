//
//  Plant+Convenience.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit
import CoreData


extension Plant {
    // MARK: - Properties

    // If you already have a Plant, this will turn it into it's representation
    var plantRepresentation: PlantRepresentation? {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let today = Date()
        guard let nickname = nickname else { return nil }
        return PlantRepresentation(id: Int16?(id),
                                   nickname: nickname,
                                   species: species ?? "",
                                   h20Frequency: Int16(h20Frequency),
                                   userId: Int(userId),
                                   avatar: avatar,
                                   lastWateredAt: lastWateredAt)
    }

    // MARK: - Convenience Initalizers
    // Plant data object Initalizer
    @discardableResult convenience init(
        id: Int16?,
        nickname: String,
        species: String,
        h20Frequency: Int16,
        avatar: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.species = species
        self.h20Frequency = h20Frequency
        self.avatar = avatar
    }

    // This will convert a PlantRepresentation into a Plant object for saving on Coredata
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(
            id: plantRepresentation.id,
            nickname: plantRepresentation.nickname,
            species: plantRepresentation.species ?? "",
            h20Frequency: Int16(plantRepresentation.h20Frequency ?? 0),
            avatar: plantRepresentation.avatar ?? "",
            context: context)
    }


}



