//
//  PlantDetailControlller.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://watermyplants2020.herokuapp.com/")!
let getURL = baseURL.appendingPathComponent("/api/plants/:id")
let putURL = baseURL.appendingPathComponent(" /api/plants/:id")
let deleteURL = baseURL.appendingPathComponent("/api/plants/:id")

class PlantDetailController  {
    
    typealias CompletionHandler = (Error?) -> Void
    
    
    init() {
        print("INIT")
        fetchPlantsFromServer()
    }
    
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = getURL
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching plants: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            
            do {
                let plantRepresentations = Array(try jsonDecoder.decode([String: PlantRepresentation].self, from: data).values)
                try self.updatePlants(with: plantRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing plant representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }.resume()
    }
    
    
    func savePlant() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func deletePlantFromServer(plant: Plants, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let uuid = plant.id else {
            completion(NSError())
            return
        }
        let requestURL = deleteURL
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            
            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
    
    func sendPlantToServer(plant: Plants, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = plant.id ?? UUID()
        let requestURL = putURL
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
    }
    
    func update(nickname: String, species: String, h20frequency: Int16, plant: Plants) {
        plant.nickname = nickname
        plant.species = species
        plant.h20frequency = Int16
        sendPlantToServer(plant: plant)
        savePlant()
    }
    
    private func updatePlants(with representations: [PlantRepresentation]) throws {
        
        let plantsWithID = representations.filter { $0.id != nil }
        
        let identifiersToFetch = plantsWithID.compactMap { $0.id! }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, plantsWithID))
        
        var plantsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Plants> = Plants.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let existingPlants = try context.fetch(fetchRequest)
                
                for plant in existingPlants {
                    
                    guard let id = plant.identifier, let representation = representationsByID[id] else {continue}
                    self.update(plant: plant, with: representation)
                    plantsToCreate.removeValue(forKey: id)
                }
                
                for representation in plantsToCreate.values {
                    Plants(plantRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching plants for UUIDs: \(error)")
            }
        }
        try CoreDataStack.shared.save(context: context)
    }
    
    private func update(plant: Plants, with representation: PlantRepresentation) {
        plant.nickname = representation.nickname
        plant.species = representation.species
        plant.h20Frequency = Int16(representation.h20Frequency)
    }
    
}
