//
//  GameMonster.swift
//  MontaskGame
//
//  Created by Tony Cioara on 11/20/17.
//  Copyright © 2017 Tony Cioara. All rights reserved.
//

import Foundation
import SpriteKit

class GameMonster: SKSpriteNode {
    
    var health = 300
    var power = 30
    var critChance = 30
    
    /* You are required to implement this for your subclass to work */
    
    init(image: String, health: Int, power: Int, critChance: Int) {
        let texture = SKTexture(imageNamed: image)
        let color = UIColor.clear
        let size = texture.size()
        
        super.init(texture: texture, color: color, size: size)
        
        self.health = health
        self.power = power
        self.critChance = critChance
        
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

