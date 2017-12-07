//
//  Egg.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/22/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

class Egg {
    let tier: String
    let price: Int
    let monsters: [MonsterModel]
    let imageURL: String
    
    init(price: Int, monsters: [MonsterModel], tier: String, url: String) {
        self.price = price
        self.monsters = monsters
        self.tier = tier
        self.imageURL = url
    }
    
}
