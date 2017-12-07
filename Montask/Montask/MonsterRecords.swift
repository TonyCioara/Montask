//
//  MonsterRecords.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/22/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation

//How should I save the models of all the monsters?
//We dont need the actual monster object, we just want the average stats of every monster
//I was thinking of making a dictionary, key is the name, and value is the group of average stats of the monster
//Or maybe have each monster be its own dictionary?
//How about having each monster have its own class

class MonsterModel {
    var name: String
    var power: Int
    var specialPower: Int
    var health: Int
    var imageURL: String
    
    init(name: String, power: Int, specialPower: Int, health: Int, imageURL: String) {
        self.name = name
        self.power = power
        self.specialPower = specialPower
        self.health = health
        self.imageURL = imageURL
    }
}


let glowGhost = MonsterModel(name: "GlowGhost", power: 30, specialPower: 60, health: 400, imageURL: "Ghost Export")

let Slime = MonsterModel(name: "Slime", power: 20, specialPower: 50, health: 500, imageURL: "Slime Export")

let RootEye = MonsterModel(name: "RootEye", power: 50, specialPower: 100, health: 300, imageURL: "Eye Export")

let PirateSpriteShip = MonsterModel(name: "PirateSpriteShip", power: 400, specialPower: 800, health: 4000, imageURL: "Pirate ship export")


//var GlowGhost: [String: Any] = ["name": "GlowGhost", "power": 30, "specialPower": 60, "health": 400, "imageURL": "https://s3-us-west-1.amazonaws.com/monsterfiles/monsterimages/Ghost%402x.png"]

var fkOffSlime: [String: Any] = ["name": "Slime", "power": 20, "specialPower": 50, "health": 500, "imageURL": "https://s3-us-west-1.amazonaws.com/monsterfiles/monsterimages/Slime.png"]

var burettasaur: [String: Any] = ["name": "Burettasaur", "power": 50, "specialPower": 100, "health": 1000, "imageURL": "https://static.giantbomb.com/uploads/scale_small/13/135472/1898251-034nidoking.png"]

var wingedPigMino: [String: Any] = ["name": "WingedPigMino", "power": 2000, "specialPower": 10000, "health": 5000, "imageURL": "https://static.giantbomb.com/uploads/scale_small/13/135472/1891841-094gengar.png"]

//var monsterRecords: [[String: Any]] = [burettasaur, wingedPigMino, fkOffSlime, GlowGhost]

var monsterModels: [MonsterModel] = [glowGhost, Slime, RootEye, PirateSpriteShip]

