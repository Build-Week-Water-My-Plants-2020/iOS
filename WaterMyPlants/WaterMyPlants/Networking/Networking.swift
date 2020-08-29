//
//  Networking.swift
//  WaterMyPlants
//
//  Created by Morgan Smith on 8/19/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case badUrl
    case noDecode
    case networkError
    case failedSignIn
    case noToken
    
}

class Networking {
    typealias ClassCompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://watermyplants2020.herokuapp.com/api/")

    static let sharedNetworkController = Networking()
    var token: Token?
    var allUsers: [UserRepresentation] = []
    var allPlants: [PlantRepresentation] = []
    var currentUserServerPlants: [PlantRepresentation] = [] {
        didSet {
            print("this is the current user Server plants: \(currentUserServerPlants)")
        }
    }
    var currentUserPlants: [Plant] = [] {
        didSet {
            print("this is the current user plants: \(currentUserPlants)")
        }
    }

    var currentRegisteredUser: UserRepresentation? {
        didSet {
            DispatchQueue.global().async {
                let dispatchGroup = DispatchGroup()

                dispatchGroup.enter()
                self.fetchRegisteredUsers() { error in
                    print(error)
                    dispatchGroup.leave()
                }
                dispatchGroup.wait()
                dispatchGroup.enter()
                let filteredUsers = self.allUsers.filter({$0.username.contains(self.currentRegisteredUser!.username)})
                let userAuth: UserRepresentation = filteredUsers[0]
                self.createRegisteredUser(with: userAuth)
                print("This is the current registered user: \(String(describing: self.currentRegisteredUser))")
                dispatchGroup.leave()
                dispatchGroup.wait()
            }

        }
    }

    var currentCDUser: User? {
        didSet{
            print("this is the core data logged in current user: \(String(describing: currentCDUser))")
        }
    }

    init() {
        fetchPlantsFromServer()
        fetchRegisteredUsers()
    }
    
    
    func registerUser(with user: UserRepresentation, completion: @escaping CompletionHandler = { _ in }) {
        guard let registerURL = baseURL?.appendingPathComponent("auth/register") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(response)
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error { completion(error); return}
            guard let data = data else { completion(NSError()); return}
            self.currentRegisteredUser = user
        }.resume()
    }
    
    func loginUser(with user: UserRepresentation, completion: @escaping ClassCompletionHandler) {
        
        guard let requestURL = baseURL?.appendingPathComponent("auth/login") else {
            completion(.failure(.badUrl))
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("Error encoding user object: \(error)")
            completion(.failure(.failedSignIn))
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Sign in failed with error: \(error)")
                completion(.failure(.failedSignIn))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode != 201 else {
                    completion(.failure(.failedSignIn))
                    return
            }
            
            guard let data = data else {
                print("Data not received")
                completion(.failure(.failedSignIn))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.token = try decoder.decode(Token.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(.failure(.failedSignIn))
                return
            }
            self.fetchUserCD(with: user)
        }.resume()
    }

    private func fetchRegisteredUsers(completion: @escaping ClassCompletionHandler = { _ in }) {
        guard let requestURL = baseURL?.appendingPathComponent("users") else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching all users: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            guard let data = data else {
                print("No data returned by data users")
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }

            let decoder = JSONDecoder()

            do {
                let allUsers = try decoder.decode([UserRepresentation].self, from: data)
                self.allUsers = allUsers
                print("successfully decoded allUsers from networkController \(allUsers)")
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                print("Error decoding user representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
        }.resume()

    }

    private func fetchUserCD(with representation: UserRepresentation) {
        let fetchRequestUser: [User]? = {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let moc = CoreDataStack.shared.mainContext
            var fetchedUser: [User] = []
            do {
                fetchedUser = try moc.fetch(fetchRequest)
            } catch {
                NSLog("error fetching User objects")
            }
            return fetchedUser
        }()

        if let results = fetchRequestUser {
            let filteredUser = results.filter({($0.username?.contains(representation.username))!})
            let filtered = filteredUser[0]
            self.currentCDUser = filtered
        } else {
            print("error matching server user to core data")
        }
    }
    
    private func createRegisteredUser(with representation: UserRepresentation) {
        User(userRepresentation: representation)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("error saving registered user to core data)")
        }
    }

    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        guard let registerURL = baseURL?.appendingPathComponent("plants") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
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
                let plantRepresentations = try jsonDecoder.decode([PlantRepresentation].self, from: data)
                self.allPlants = plantRepresentations
                print("successfully decoded allPlants from networkController \(self.allPlants)")
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

    func deletePlantFromServer(plant: Plant, completion: @escaping CompletionHandler = { _ in }) {

        guard let id = plant.plantRepresentation?.id, let token = token, let deleteURL = baseURL?.appendingPathComponent("plants/\(id)") else { return }

        var request = URLRequest(url: deleteURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, _, error in
            print("Deleted plant with ID: \(id)")
            completion(error)
        }.resume()
    }

    func sendPlantToServer(plant: Plant, completion: @escaping ClassCompletionHandler = { _ in }) {
        guard let token = token, let createURL = baseURL?.appendingPathComponent("auth/myplants") else { return }

        var request = URLRequest(url: createURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token.token, forHTTPHeaderField: "Authorization")

        let jsonEncoder = JSONEncoder()

        do {
            guard let representation = plant.plantRepresentation else { return }
            let jsonData = try jsonEncoder.encode(representation)
            request.httpBody = jsonData
        } catch {
            print("Error encoding plant object: \(error)")
            completion(.failure(.noDecode))
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error fetching sending plant to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            completion(.success(true))
        }.resume()
    }


    func updatePlantOnServer(for plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = plant.plantRepresentation?.id, let token = token, let updateURL = baseURL?.appendingPathComponent("plants/\(id)") else { return }

        var request = URLRequest(url: updateURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")

        let jsonEncoder = JSONEncoder()

        do {
            guard let representation = plant.plantRepresentation else {
                return
            }
            let jsonData = try jsonEncoder.encode(representation)
            request.httpBody = jsonData
        } catch {
            print("Error encoding edited plant: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }

            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func updatePlantOnCD(with plant: Plant, nickName: String, species: String, h2oFrequency: String) {
        plant.nickName = nickName
        plant.species = species
        plant.h2oFrequency = h2oFrequency
        self.updatePlantOnServer(for: plant) { (error) in
            if let error = error {
                print("Error for updating Plant on Server: \(error)")
            }
        }
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }

    func fetchUserPlants(with user: User, completion: @escaping CompletionHandler = { _ in }) {
        guard let token = token, let id = user.userRepresentation?.id, let registerURL = baseURL?.appendingPathComponent("users/\(id)/plants") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token.token, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
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

            do {
                let plantRepresentations = try jsonDecoder.decode([PlantRepresentation].self, from: data)
                self.currentUserServerPlants = plantRepresentations
                self.currentUserPlants = []
                for plant in plantRepresentations {
                    let newPlant = Plant(plantRepresentation: plant)
                    if let newPlant = newPlant {
                    self.currentUserPlants.append(newPlant)
                    }
                }
                print("successfully decoded currentUserPlants from networkController \(self.currentUserPlants)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding current user plant representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }

        }.resume()

    }

    private func update(plant: Plant, with representation: PlantRepresentation) {
        plant.nickName = representation.nickName
        plant.species = representation.species
        plant.h2oFrequency = representation.h2oFrequency 
    }
    
}



