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

class GameViewController: UIViewController, GameSceneDelegate {
    
    var monster1: Monster!
    var monster2: Monster!
    
    func gameOver() {
        print("Game Over")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monster1 = Monster(name: "ABC", power: 125, specialName: "ABC", specialPower: 250, health: 3000, userEmail: "fdsfsg", imageUrl: "Eye Export")
        
        self.monster2 = Monster(name: "ABC", power: 125, specialName: "ABC", specialPower: 250, health: 3000, userEmail: "fdsfsg", imageUrl: "Eye Export")

        let gameMonster1: GameMonster = GameMonster(image: monster1.imageUrl, health: monster1.health, power: monster1.power, critChance: monster1.specialPower)
        let gameMonster2: GameMonster = GameMonster(image: monster2.imageUrl, health: monster2.health, power: monster2.power, critChance: monster2.specialPower)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                
                scene.gameSceneDelegate = self

                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                scene.userData = NSMutableDictionary()
                scene.userData?.setObject(gameMonster1, forKey: "gameMonster1" as NSCopying)
                scene.userData?.setObject(gameMonster2, forKey: "gameMonster2" as NSCopying)
                
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
