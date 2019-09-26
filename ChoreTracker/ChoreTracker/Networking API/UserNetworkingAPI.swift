//
//  UserNetworkingAPI.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/26/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class UserNetworkingAPI {
    
    static let shared = UserNetworkingAPI()
    static var userToken: String?

    func signUp(with user: APIUser, completion: @escaping (Error?) -> Void) {
        let appendedURL = baseAPIURL.appendingPathComponent("/api/auth/register")
        var request = URLRequest(url: appendedURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(user)
            request.httpBody = data
        } catch {
            NSLog("UserNetworkingAPI: Error encoding user info: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NetworkError.failedSignUp(NSError(domain: baseAPIURL.absoluteString, code: response.statusCode, userInfo: nil)))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func signIn(with user: APIUser, completion: @escaping (Error?) -> Void) {
        let appendedURL = baseAPIURL.appendingPathComponent("/api/auth/login")
        var request = URLRequest(url: appendedURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(user)
            request.httpBody = data
        } catch {
            NSLog("UserController: Error encoding user info: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NetworkError.failedSignUp(NSError(domain:  baseAPIURL.absoluteString, code: response.statusCode, userInfo: nil)))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let data = data else { completion(NetworkError.invalidData); return}
            do {
                let loginResponse: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                UserNetworkingAPI.userToken = loginResponse.token
            } catch {
                NSLog("UserController: Error decoding token: \(error)")
                completion(NetworkError.noDecode)
                return
            }
            completion(nil)
            }.resume()
        
    }



}

