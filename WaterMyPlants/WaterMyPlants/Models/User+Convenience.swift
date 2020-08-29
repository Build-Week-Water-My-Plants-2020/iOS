//
//  User+Convenience.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit
import CoreData


extension User {
    // MARK: - Properties

    /// Object passed to Backend
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let password = password
            else {
                print("Error creating UserRepresentation for backend.")
                return nil
        }

        return UserRepresentation(id: Int(id),
                                  username: username,
                                  password: password,
                                  phoneNumber: phoneNumber ?? "")
    }

    // MARK: - Initalizers

    /// Creates User with the same Managed Object Context "moc" -> Local -> CoreData
    @discardableResult convenience init(id: Int16,
                                        username: String,
                                        password: String,
                                        phoneNumber: String,
                                        avatar: String? = "",
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        self.id = id
        self.username = username
        self.password = password
        self.phoneNumber = phoneNumber
        self.avatar = avatar
    }

    /// Creates User from UserRepresentation Data (Backend Data) -> CoreData
    @discardableResult
    convenience init?(userRepresentation: UserRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(id: Int16(userRepresentation.id ?? 1),
                  username: userRepresentation.username,
                  password: userRepresentation.password,
                  phoneNumber: userRepresentation.phoneNumber ?? "",
                  avatar: userRepresentation.avatar ?? "",
                  context: context)
    }
}
