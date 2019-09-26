//
//  UserController.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/23/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

class UserController {
    
    static let shared = UserController()
    let userNetworkingAPI = UserNetworkingAPI()
    static var currentUser: User?
    
    init() {
        //fetchUsersFromServer()
    }
    
    func sync(completion: @escaping () -> Void = {}) {
        //fetchUsersFromServer()
        completion()
    }
    
    @discardableResult func create(id: Int32, name: String, loginName: String, password: String, emailAddress: String?, child: Bool, picture: String?) throws -> User? {
        guard uniqueLoginName(loginName: loginName) else
        {
            throw (AppError.nameNotUnique)
        }
        let user = User(id: id,loginName: loginName, password: password, name: name, emailAddress: emailAddress,child: child, picture: picture, context: CoreDataStack.shared.mainContext)
        if user.child { user.parent = UserController.currentUser}
        CoreDataStack.shared.save()
        //put(representation: user.userRepresentation)
        return user
    }
    
    func uniqueLoginName (loginName: String) -> Bool {
        var unique: Bool = false
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        do {
            let loginNames = try context.fetch(fetchRequest).map({$0.loginName})
            unique = !loginNames.contains(loginName)
        } catch {
            NSLog("uniqueLoginName: Error fetching users")
        }
        return unique
    }
    
    func update(user: User, name: String, loginName: String, password: String, emailAddress: String?, child: Bool, picture: String?) {
        user.name = name
        user.loginName = loginName
        user.password = password
        user.emailAddress = emailAddress
        user.child = child
        user.picture = picture
        if user.child && user.parent == nil { user.parent = UserController.currentUser}
        CoreDataStack.shared.save()
        //put(representation: user.userRepresentation)
    }
    
    func delete(user: User) {
        CoreDataStack.shared.mainContext.delete(user)
        CoreDataStack.shared.save()
        //Implement delete from Firebase?
    }
    
    func login(loginName: String, password: String) throws -> Bool {
        if useAPI {
            //TODO: - Do Network call and get and save token
            let user = APIUser(name: nil, username: loginName, email: nil, password: password)
            userNetworkingAPI.signIn(with: user) { (error) in
                if let error = error {
                    
                } else {
                    
                }
            }
        } else {
            //Mock up with local DB
            let context = CoreDataStack.shared.mainContext
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            do {
                fetchRequest.predicate = NSPredicate(format: "loginName == %@", loginName)
                let users = try context.fetch(fetchRequest)
                if users.count > 0 {
                    if users[0].password ?? "" == password {
                        UserController.currentUser = users[0]
                        return true
                    } else {
                        NSLog("Error loggin in with local DB, password did not match.")
                        throw(AppError.loginFailedWrongPassword)
                    }
                } else {
                    throw (AppError.loginFailedLoginName)
                }
            } catch {
                NSLog("Error fetching user(s) with loginName: \(error)")
                throw (AppError.errorFetchingData)
            }
        }
        return true
    }
    
    func getNextID () -> Int32? {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        var idNumber: Int32
        do {
            fetchRequest.predicate = NSPredicate(value: true)
            let users = try context.fetch(fetchRequest)
            idNumber = Int32(users.count)
            let allIDs = users.map ( { $0.id } )
            while allIDs.contains(idNumber) {
                idNumber += 1
            }
        } catch {
            NSLog("Error fetching users for getNextID: \(error)")
            return nil
        }
        return idNumber
    }
    
    @discardableResult func register(loginName: String,
                                     password: String,
                                     name: String,
                                     emailAddress: String?,
                                     child: Bool,
                                     picture: String?) throws -> User?
    {
        var user: User?
        if useAPI {
            //TODO: - Do Network call and get and save token
            let apiUser = APIUser(name: name, username: loginName, email: emailAddress, password: password)
            do {
                try userNetworkingAPI.signUp(with: apiUser)
            } catch {
                
            }
        } else {
            //Mock up with local DB
            guard let id = getNextID() else { return nil }
            if debuging { print ("User Register: ID = \(id)") }
            do {
                user =  try create(id: id, name: name, loginName: loginName, password: password, emailAddress: emailAddress, child: child, picture: picture)
                if debuging { print ("User Register: user created = \(String(describing: user))") }
                return user
            } catch {
                throw error
            }
        }
        return nil
    }
    
    func getUser (from id: Int32)->User? {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            let users = try context.fetch(fetchRequest)
            return users[0]
        } catch {
            return nil
        }
    }
    
    //TODO: Finish this out
    func getUserStats(with user: User, preiod: Period = Period.weekly) -> [String:Int] {
        
        let startDate:Date = Date.today().previous(.monday)
        let endDate: Date = Date.today().next(.sunday)
        let dateRange = startDate...endDate
        //Get assigned chores count
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
        do {
            //fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            let chores = try context.fetch(fetchRequest)
            //return users[0]
        } catch {
            //return nil
        }
        //Get done chore count
        //Get needs approval chore count
        //get total points for period
        
        
        
        return [:]
    }
    
    //MARK: - JSON API code
    let objectType: String = "User"
    
    func put(representation: UserRepresentation?, completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        guard let representation = representation else {
            NSLog("\(objectType) Representation is nil for put function.")
            completion(AppError.objectToRepFailed)
            return
        }
        let idString = String(representation.id)
        let requestURL = baseURL.appendingPathComponent(idString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(representation)
            print ("HTTP Body: \(String(describing: request.httpBody))")
        } catch {
            NSLog("Error encoding task respresentation: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error PUTing entry: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
//    func fetchUsersFromServer(completion: @escaping (_ error: Error?) -> Void = { _ in }) {
//        let requestURL = baseURL.appendingPathExtension("json")
//        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
//            if let response = response as? HTTPURLResponse {
//                if response.statusCode != 200 {
//                    print ("HTTP Response: \(response)")
//                    completion(NetworkError.responseError)
//                }
//            }
//            if let error = error {
//                NSLog("Error fetching entries: \(error)")
//                completion(NetworkError.responseError)
//            }
//            guard let data = data else {
//                NSLog("No data returned from entries")
//                completion(NetworkError.noData)
//                return
//            }
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            do {
//                let userRepresentations =  try decoder.decode([String: UserRepresentation].self, from: data).map({ $0.value })
//                self.updateEntries(with: entryRepresentations)
//            } catch {
//                NSLog("Error decoding: \(error)")
//                completion(NetworkError.noDecode)
//            }
//            }.resume()
//        completion(nil)
//    }
//    
//    private func updateUsers(with representations: [UserRepresentation]) {
//        let identifiersToFetch = representations.compactMap({UUID(uuidString: $0.identifier)})
//        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
//        var entriesToCreate = representationsByID
//        let context = CoreDataStack.shared.container.newBackgroundContext()
//        let fetchRequest: NSFetchRequest<User> = Entry.fetchRequest()
//        context.performAndWait {
//            //Update Local store with Firebase
//            do {
//                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
//                let existingEntries = try context.fetch(fetchRequest)
//                for entry in existingEntries {
//                    guard let identifier = entry.identifier,
//                        var representation = representationsByID[identifier] else { continue }
//                    //Update FROM Firebase if it's newer
//                    if let timestamp = entry.timeStamp, timestamp < representation.timeStamp {
//                        entry.title = representation.title
//                        entry.bodyText = representation.bodyText
//                        entry.mood = representation.mood
//                        entry.timeStamp = representation.timeStamp
//                        entriesToCreate.removeValue(forKey: identifier)
//                    } else { //Update TO Firebase with local if newer
//                        representation.title = entry.title!
//                        representation.bodyText = entry.bodyText
//                        representation.mood = entry.mood!
//                        representation.timeStamp = entry.timeStamp!
//                        put (representation: representation)
//                    }
//                }
//                NSLog("Creating \(entriesToCreate.count) entries from Firebase to local store.")
//                for representation in entriesToCreate.values {
//                    Entry(entryRepresentaion: representation, context: context)
//                }
//                CoreDataStack.shared.save(context: context)
//            } catch {
//                NSLog("Error fatching entries from persistent store: \(error)")
//            }
//            //Update Firebase with local only entries
//            do {
//                fetchRequest.predicate = NSPredicate(value: true)
//                let allLocalEntries = try context.fetch(fetchRequest)
//                let newLocalEntries = allLocalEntries.filter({!identifiersToFetch.contains($0.identifier!)})
//                print ("New local entries to Firebase: \(newLocalEntries.count)")
//                for entry in newLocalEntries {
//                    put(representation: entry.entryRepresentation)
//                }
//            } catch {
//                NSLog("Error putting new local entries to Firebase: \(error)")
//            }
//        }
//    }
}
