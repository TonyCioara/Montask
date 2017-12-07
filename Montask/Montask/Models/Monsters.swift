//
//  Monsters.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/11/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

struct Monster: Codable {
    let name: String
    let power: Int
    let specialName: String
    let specialPower: Int
    let health: Int
    let userEmail: String
    let imageUrl: String
    
}

extension Monster {
    enum codingKey: String, CodingKey {
        case name
        case power
        case specialName = "special_name"
        case specialPower = "special_power"
        case health
        case userEmail = "user_email"
        case imageUrl = "image_url"
        
    }
    
    func encode(to encoder: Encoder) throws {
        var value = encoder.container(keyedBy: codingKey.self)
        try value.encode(name, forKey: .name)
        try value.encode(power, forKey: .power)
        try value.encode(specialName, forKey: .specialName)
        try value.encode(specialPower, forKey: .specialPower)
        try value.encode(health, forKey: .health)
        try value.encode(userEmail, forKey: .userEmail)
        try value.encode(imageUrl, forKey: .imageUrl)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKey.self)
        let specialName = try container.decode(String.self, forKey: .specialName)
        let specialPower = try container.decode(Int.self, forKey: .specialPower)
        let userEmail = try container.decode(String.self, forKey: .userEmail)
        let name = try container.decode(String.self, forKey: .name)
        let power = try container.decode(Int.self, forKey: .power)
        let health = try container.decode(Int.self, forKey: .health)
        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
        
        self.init(name: name, power: power, specialName: specialName, specialPower: specialPower, health: health, userEmail: userEmail, imageUrl: imageUrl)
    }
    
}
