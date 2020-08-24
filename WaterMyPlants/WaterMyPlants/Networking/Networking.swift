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
    case noDecode
}

class NetworkController {
    typealias ClassCompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias CompletionHandler = (Error?) -> Void

    private let baseURL = URL(string: "https://watermyplants2020.herokuapp.com/api/")
    static let sharedNetworkController = NetworkController()
    var token: Bearer?

    func registerUser(with user: UserRepresentation, completion: @escaping CompletionHandler = { _ in}) {
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
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error { completion(error); return}
            guard let data = data else { completion(NSError()); return}

            let decoder = JSONDecoder()
            do {
                let currentUser = try decoder.decode(UserRepresentation.self, from: data)
                self.createRegisteredUser(with: currentUser)
            } catch {
                print("Error decoding registered user: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func loginUser(with user: UserRepresentation, completion: @escaping CompletionHandler = { _ in}) {
        guard let requestURL = baseURL?.appendingPathComponent("auth/login") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: requestURL)
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
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }

            if let error = error { completion(error); return}
            guard let data = data else { completion(NSError()); return}

            let decoder = JSONDecoder()

            do {
                self.token = try decoder.decode(Bearer.self, from: data)
                print(String(describing: self.token))
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    private func createRegisteredUser(with representation: UserRepresentation) {
        User(userRepresentation: representation)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("error saving registered user to core data)")
        }
    }

}



