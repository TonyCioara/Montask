//
//  User.swift
//  Montask
//
//  Created by Sunny Ouyang on 10/30/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation
import UIKit

class User: Codable {
    
    var username: String
    var email: String
    var monsters: [Monster]
    var points: Int
    var level: Int
    static let sharedInstance = User()
    
    static func sharedInstanceWith(username: String, monsters: [Monster], points: Int, level: Int) -> User {
        //We don't need to have the requests or friends, because we just pass to the server the username, and we can search for the User Object in our database, so that means we shouldn't have to make any changes for when we added requests
        let instance = User.sharedInstance
        instance.username = username
        instance.email = username
        instance.monsters = monsters
        instance.points = points
        instance.level = level
        return instance
    }
    
    init(username: String, email: String, points: Int, level: Int) {
        self.username = username
        self.email = email
        self.monsters = []
        self.points = points
        self.level = level
    }
    

    convenience init(username: String = "", points: Int = 0, level: Int = 0) {
        self.init(username: username, email: username, points: points, level: level)
    }
}


