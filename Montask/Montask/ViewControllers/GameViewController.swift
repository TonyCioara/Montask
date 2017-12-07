//
//  GameViewController.swift
//  MontaskGame
//
//  Created by Tony Cioara on 12/7/17.
//  Copyright © 2017 Tony Cioara. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var monster1: Monster!
    var monster2: Monster!
    
    func convertMonstersToGameMonsters() {
        
        var gameMonster1: GameMonster = GameMonster(image: monster1.imageUrl, health: monster1.health, power: monster1.power, critChance: monster1.specialPower)
        var gameMonster2: GameMonster = GameMonster(image: monster2.imageUrl, health: monster2.health, power: monster2.power, critChance: monster2.specialPower)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
