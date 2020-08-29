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
        return PlantRepresentation(nickName: nickName ?? "none",
                                   species: species ?? "none",
                                   h2oFrequency: h2oFrequency ?? "1",
                                   image: image ?? "",
                                   dateLastWatered: dateLastWatered ?? "Aug 1", notificationEnabled: notificationEnabled, notificationTime: notificationTime ?? "10:30:00", userId: Int(userId))
    }

    // MARK: - Convenience Initalizers
    // Plant data object Initalizer
    @discardableResult convenience init(
        id: Int16? = 0,
        nickName: String,
        species: String,
        h2oFrequency: String,
        userId: Int16? = 0,
        image: String,
        dateLastWatered: String,
        notificationEnabled: Bool = false,
        notificationTime: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id ?? 0
        self.nickName = nickName
        self.species = species
        self.h2oFrequency = h2oFrequency
        self.userId = userId ?? 0
        self.image = image
        self.dateLastWatered = dateLastWatered
        self.notificationTime = notificationTime
    }

    // This will convert a PlantRepresentation into a Plant object for saving on Coredata
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
       // self.init(context: context)
        self.init(
            id: Int16(plantRepresentation.id ?? 0),
            nickName: plantRepresentation.nickName,
            species: plantRepresentation.species,
            h2oFrequency: plantRepresentation.h2oFrequency,
            userId: Int16(plantRepresentation.userId ?? 0),
            image: plantRepresentation.image, dateLastWatered: plantRepresentation.dateLastWatered, notificationTime: plantRepresentation.notificationTime)


    }


}



