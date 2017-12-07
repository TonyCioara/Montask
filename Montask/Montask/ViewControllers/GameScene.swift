//
//  GameScene.swift
//  MontaskGame
//
//  Created by Tony Cioara on 11/20/17.
//  Copyright © 2017 Tony Cioara. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player1: GameMonster!
    var player2: GameMonster!
    
    var targetOrigin: SKSpriteNode!
    
    var victoryMainMenu: MSButtonNode!
    var defeatMainMenu: MSButtonNode!
    var victoryTitle: SKSpriteNode!
    var defeatTitle: SKSpriteNode!
    var victoryRestart: MSButtonNode!
    var defeatRestart: MSButtonNode!
    var endGameBackground: SKSpriteNode!
    
    var player1HPLabel: SKLabelNode!
    var player2HPLabel: SKLabelNode!
    
    var player1PowerLabel: SKLabelNode!
    var player2PowerLabel: SKLabelNode!
    
    var gameRunning = true
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    let attackFrequency = 2.0
    var attackTimer = 2.0
    let targetSpawnFrequency = 1.0
    var targetSpawnTimer = 1.0
    
    override func didMove(to view: SKView) {
        player1 = childNode(withName: "//player1") as! GameMonster
        player2 = childNode(withName: "//player2") as! GameMonster
        
        player1HPLabel = childNode(withName: "//player1HPLabel") as! SKLabelNode
        player2HPLabel = childNode(withName: "//player2HPLabel") as! SKLabelNode
        
        player1PowerLabel = childNode(withName: "//player1PowerLabel") as! SKLabelNode
        player2PowerLabel = childNode(withName: "//player2PowerLabel") as! SKLabelNode
        
        player1PowerLabel.text = String(player1.power)
        player2PowerLabel.text = String(player2.power)
        
        victoryMainMenu = childNode(withName: "//victoryMainMenu") as! MSButtonNode
        defeatMainMenu = childNode(withName: "//defeatMainMenu") as! MSButtonNode
        victoryTitle = childNode(withName: "//victoryTitle") as! SKSpriteNode
        defeatTitle = childNode(withName: "//defeatTitle") as! SKSpriteNode
        victoryRestart = childNode(withName: "//victoryRestart") as! MSButtonNode
        defeatRestart = childNode(withName: "//defeatRestart") as! MSButtonNode
        endGameBackground = childNode(withName: "//endGameBackground") as! SKSpriteNode
        
        victoryMainMenu.selectedHandler = { [unowned self] in
            self.mainMenuButton()
        }
        
        defeatMainMenu.selectedHandler = { [unowned self] in
            self.mainMenuButton()
        }
        
        victoryRestart.selectedHandler = { [unowned self] in
            self.restartButton()
        }
        
        defeatRestart.selectedHandler = { [unowned self] in
            self.restartButton()
        }
        
        endGameBackground.isHidden = true
        defeatTitle.isHidden = true
        defeatMainMenu.isHidden = true
        defeatRestart.isHidden = true
        victoryTitle.isHidden = true
        victoryMainMenu.isHidden = true
        victoryRestart.isHidden = true
        
        
        targetOrigin = childNode(withName: "//targetOrigin") as! SKSpriteNode
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        if gameRunning == false {
            return
        }
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "target"
            {
                hitTarget(target: touchedNode)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func attack(attacker: GameMonster, defender: GameMonster) {
        defender.health -= attacker.power
    }
    
    func win() {
        victoryTitle.isHidden = false
        victoryMainMenu.isHidden = false
        victoryRestart.isHidden = false
        endGameBackground.isHidden = false
        gameRunning = false
        
    }
    
    func lose() {
        defeatTitle.isHidden = false
        defeatMainMenu.isHidden = false
        defeatRestart.isHidden = false
        endGameBackground.isHidden = false
        gameRunning = false
    }
    
    func gameOverCheck() {
        if player2.health == 0 {
            win()
        }
        else if player1.health == 0 {
            lose()
        }
    }
    
    func botAttackUpdate() {
        attackTimer -= fixedDelta
        if attackTimer <= 0 {
            attackTimer = attackFrequency
            attack(attacker: player2, defender: player1)
        }
    }
    
    func targetSpawnUpdate() {
        targetSpawnTimer -= fixedDelta
        if targetSpawnTimer <= 0 {
            targetSpawnTimer = targetSpawnFrequency
            createTarget()
        }
    }
    
    func createTarget() {
        let xPosition = 275 - Int(arc4random_uniform(550))
        let yPosition = 150 + Int(arc4random_uniform(430))
        let target = targetOrigin.copy() as! SKSpriteNode
        target.position.x = CGFloat(xPosition)
        target.position.y = CGFloat(yPosition)
        target.name = "target"
        self.addChild(target)
    }
    
    func hitTarget(target: SKNode) {
        target.removeFromParent()
        attack(attacker: player1, defender: player2)
    }
    
    func restartButton() {
        //        1) Grab reference to our SpriteKit view
        guard let skView = self.view as SKView! else {
            print ("Could not get SkView")
            return
        }
        
        //        2) Load scene
        guard let scene = GameScene(fileNamed: "GameScene") else {
            print ("Could not make scene")
            return
        }
        
        //        3) Ensure correct aspect mode
        print("scene = \(String(describing: scene))")
        scene.scaleMode = .aspectFit
        
        //        Show debug
        skView.showsPhysics = false
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        //        4) Start Game scene
        skView.presentScene(scene)
    }
    
    func mainMenuButton() {
        
    }
    
    func updateLabels() {
        player1HPLabel.text = String(player1.health)
        player2HPLabel.text = String(player2.health)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameRunning == false {
            return
        }
        
        targetSpawnUpdate()
        botAttackUpdate()
        gameOverCheck()
        updateLabels()
    }
}
