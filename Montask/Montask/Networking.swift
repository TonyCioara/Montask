//
//  Networking.swift
//  Montask
//
//  Created by Sunny Ouyang on 10/30/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

enum Route {
   

    case postUser(email: String, password: String, points: Int, level: Int)
    case getUser
    case getFightingUsers(level: Int)
    case patchUser(points: Int, username: String, level: Int)
    case patchUserRequests(senderName: String)
    case postTask(email: String, name: String, description: String, taskLength: String, completionPercentage: Int, timeCreated: String)
    case getTasks
    case patchTask(task: Task, completed: Bool)
    case postMonster(userEmail: String, name: String, power: Int, specialName: String, specialPower: Int, health: Int, imageURL: String)
    case getMonsters
    case addFriend(userEmail: String)
    case getFriends
    case getFriendsMonsters
    case getFriendRequests
    case postFriendRequest(sender: String, receiver: String)
    
    

    
    
    
    func method() -> String {
        
        switch self {
         
        case .postUser, .postTask, .postMonster, .addFriend, .postFriendRequest:
            return "POST"
        case .getUser, .getTasks, .getMonsters, .getFriends, .getFriendsMonsters, .getFriendRequests, .getFightingUsers:
            return "GET"
        case .patchUser, .patchTask, .patchUserRequests:
            return "PATCH"
        
       
        }
    }
    
    
    func path() -> String {
        switch self {
        case .postUser, .getUser, .patchUser, .patchUserRequests, .getFightingUsers:
            return "users"
        case .postTask, .getTasks, .patchTask:
            return "tasks"
        case .postMonster, .getMonsters:
            return "monsters"
        case .getFriends, .addFriend:
            return "friends"
        case .getFriendsMonsters:
            return "friends_monsters"
        case .getFriendRequests, .postFriendRequest:
            return "requests"
        }
        
    }
    
    
    
    //in this body we have to return the dictionary we want to create
    func body() -> Data? {
        switch self {
        case let .getFightingUsers(level):
            let encoder = JSONEncoder()
            let body: [String:Int] = ["level": level]
            let result = try? encoder.encode(body)
            return result!
        case let .addFriend(userEmail):
            let encoder = JSONEncoder()
            let body: [String: String] = ["user_email": userEmail]
            let result = try? encoder.encode(body)
            return result!
            
        case let .patchUserRequests(senderName):
            let encoder = JSONEncoder()
            let body: [String: String] = ["request_email": senderName]
            let result = try? encoder.encode(body)
            return result!
            
        case let .patchTask(task, completed):
            var patchedTask = task
            patchedTask.completed = completed
            let encoder = JSONEncoder()
            let result = try? encoder.encode(patchedTask)
            
            return result!
            
        case let .patchUser(points, username, level):
            let user = User(username: username, email: username, points: points, level: level)
            let encoder = JSONEncoder()
            let result = try? encoder.encode(user)
            
            return result!
            
        case let .postFriendRequest(sender, receiver):
            let newRequest = Request(sender: sender, receiver: receiver)
            let encoder = JSONEncoder()
            let result = try? encoder.encode(newRequest)
            
            return result!
            
        case let .postUser(email, password, points, level):
            let user = User(username: email, email: email, points: points, level: level)

            let encoder = JSONEncoder()
            let result = try? encoder.encode(user)
            
            return result!
    
        case let .postMonster(userEmail, name, power, specialName, specialPower, health, imageURL):
            
            let monster = Monster(name: name, power: power, specialName: specialName, specialPower: specialPower, health: health, userEmail: userEmail, imageUrl: imageURL)
            let encoder = JSONEncoder()
            let result = try? encoder.encode(monster)
            return result!
            
        case let .postTask(email, name, description, taskLength, completionPercentage, timeCreated):
            
            let task = Task(userEmail: email, name: name, description: description, taskLength: taskLength, completionPercentage: completionPercentage, timeCreated: timeCreated, completed: false)
            
            let encoder = JSONEncoder()
            
            let result = try? encoder.encode(task)
            //result act as the body of our post request.
            return result
            
        default:
            return nil
        }
    }
    
    func Parameters() -> [String: String] {
        
        let date = Date()
        
        switch self {
        case let .getFightingUsers(level):
            return ["level": String(describing: level)]
            
        default:
            return [:]
            
        }
    }
    
    func headers(authorization: String) -> [String: String] {
        
        return ["Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "\(authorization)"]
    }
}


class Network {
    static let instance = Network()
    
    let baseURL = "http://127.0.0.1:5000/"
    
    let session = URLSession.shared
    
    func fetch(route: Route, token: String, completion: @escaping (Data) -> Void) {
        let fullPath = baseURL + route.path()
        
        let pathURL = URL(string: fullPath)
        let fullPathURL = pathURL?.appendingQueryParameters(route.Parameters())
        var request = URLRequest(url: fullPathURL!)
        request.httpMethod = route.method()
        request.allHTTPHeaderFields = route.headers(authorization: token)
        request.httpBody = route.body()
        
        session.dataTask(with: request) { (data, resp, err) in
            
            if let data = data {
                completion(data)
            }
            
            }.resume()
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        //
        return URL(string: URLString)!
    }
    // This is formatting the query parameters with an ascii table reference therefore we can be returned a json file
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}
