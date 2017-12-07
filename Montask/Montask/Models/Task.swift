//
//  Task.swift
//  Montask
//
//  Created by Sunny Ouyang on 10/31/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

struct Task: Codable {
    let userEmail:String
    let name:String
    let description:String
    let taskLength:String
    let completionPercentage:Int
    let timeCreated:String
    var completed:Bool
}

extension Task {
    
    enum CodingKeys: String, CodingKey {
        case userEmail = "user_email"
        case name
        case description
        case taskLength = "task_length"
        case completionPercentage = "completion_percentage"
        case timeCreated = "time_created"
        case completed
    }
    
    func encode(to encoder: Encoder) throws {
        var value = encoder.container(keyedBy: CodingKeys.self)
        try value.encode(userEmail, forKey: .userEmail)
        try value.encode(name, forKey: .name)
        try value.encode(description, forKey: .description)
        try value.encode(taskLength, forKey: .taskLength)
        try value.encode(completionPercentage, forKey: .completionPercentage)
        try value.encode(timeCreated, forKey: .timeCreated)
        try value.encode(completed, forKey: .completed)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userEmail = try container.decode(String.self, forKey: .userEmail)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let taskLength = try container.decode(String.self, forKey: .taskLength)
        let completionPercentage = try container.decode(Int.self, forKey: .completionPercentage)
        let timeCreated = try container.decode(String.self, forKey: .timeCreated)
        let completed = try container.decode(Bool.self, forKey: .completed)
        
        self.init(userEmail: userEmail, name: name, description: description, taskLength: taskLength, completionPercentage: completionPercentage, timeCreated: timeCreated, completed: completed)
    }
    
}
