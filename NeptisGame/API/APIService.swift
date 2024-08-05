//
//  APIService.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import Alamofire
import SwiftyJSON
import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://dummyjson.com"

    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(baseURL)/auth/login"
        let parameters: [String: Any] = ["username": username, "password": password]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let user = User(json: json)
                    completion(.success(user))
                case .failure(let error):
                    if let data = response.data {
                                            let json = try? JSON(data: data)
                                            let errorMessage = json?["message"].stringValue ?? "Unknown error"
                                            let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                                            completion(.failure(customError))
                                        } else {
                                            completion(.failure(error))
                                        }
                }
            }
    }
    
    func register(firstName: String, lastName: String, age: Int, username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
            let url = "\(baseURL)/users/add"
            let parameters: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "age": age,
                "username": username,
                "password": password
            ]

            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let user = User(json: json)
                        completion(.success(user))
                    case .failure(let error):
                        if let data = response.data {
                            let json = try? JSON(data: data)
                            let errorMessage = json?["message"].stringValue ?? "Unknown error"
                            let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(customError))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
        }
    
    
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
            let url = "\(baseURL)/users"

            AF.request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let users = json["users"].arrayValue.map { User(json: $0) }
                        completion(.success(users))
                    case .failure(let error):
                        if let data = response.data {
                            let json = try? JSON(data: data)
                            let errorMessage = json?["message"].stringValue ?? "Unknown error"
                            let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(customError))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
        }
    
    func getAllRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
            let url = "https://dummyjson.com/recipes"

            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
                        completion(.success(recipesResponse.recipes))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        func getAllTags(completion: @escaping (Result<[String], Error>) -> Void) {
            let url = "https://dummyjson.com/recipes/tags"

            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let tags = try JSONDecoder().decode([String].self, from: data)
                        completion(.success(tags))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    
}


struct RecipesResponse: Codable {
    let recipes: [Recipe]
}

struct TagsResponse: Codable {
    let tags: [String]
}

struct User: Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    let username: String

    init(json: JSON) {
        id = json["id"].intValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        age = json["age"].intValue
        username = json["username"].stringValue
    }
}
