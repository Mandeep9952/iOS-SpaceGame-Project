//
//  MultiPlayerGameScene.swift
//  SpaceWarriorMani
//
//  Created by Mandeep Panesar on 2018-02-05.
//  Copyright © 2018 Lambton. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class MultiPlayerGameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var player: SKSpriteNode!
    var player2: SKSpriteNode!
    var selectedPlayer: SKSpriteNode!
    
    var scoreLable: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLable.text = "Score: \(score)"
        }
    }
    
    var scoreLable2: SKLabelNode!
    var score2: Int = 0 {
        didSet {
            scoreLable2.text = "Score: \(score2)"
        }
    }
    
    var gameTimer: Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    let aliencategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory: UInt32 = 0x1 << 0
    //let photonTorpedoCategory2: UInt32 = 0
    
    
    override func didMove(to view: SKView) {
        
        
        player = SKSpriteNode(imageNamed: "shuttle")
        player.position = CGPoint(x: 35, y: frame.size.height / 2)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        player2 = SKSpriteNode(imageNamed: "shuttle-2")
        player2.position = CGPoint(x: self.frame.width - 35, y: frame.size.height / 2)
        self.addChild(player2)
        
        scoreLable = SKLabelNode(text: "Score: 0")
        scoreLable.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLable.fontName = "AmericanTypewriter-Bold"
        scoreLable.fontSize = 36
        scoreLable.fontColor = UIColor.white
        score = 0
        
        addChild(scoreLable)
        
        scoreLable2 = SKLabelNode(text: "Score: 0")
        scoreLable2.position = CGPoint(x: self.frame.size.height - 20, y: self.frame.size.height - 60)
        scoreLable2.fontName = "AmericanTypewriter-Bold"
        scoreLable2.fontSize = 36
        scoreLable2.fontColor = UIColor.white
        score2 = 0
        
        addChild(scoreLable2)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        
    }
    
    func addAlien() {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        let alien  = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAleinPosition = GKRandomDistribution(lowestValue: 90, highestValue: 950)
        let position = CGFloat(randomAleinPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = aliencategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        alien.name = "Alien"
        
        self.addChild(alien)
        
        let animationDuration: TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < self.frame.midX {
                selectedPlayer = player
                fireTorpedo(shooter: player, xPosition: self.frame.size.width + 10, yPosition: player.position.y)
            } else {
                selectedPlayer = player2
                fireTorpedo(shooter: player2, xPosition: -10, yPosition: player2.position.y)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //player.position.x = location.x
            if location.x < self.frame.midX {
              player.position.y = location.y
            }else{
                player2.position.y = location.y
            }
        }
    }
    
    func fireTorpedo(shooter: SKSpriteNode, xPosition: CGFloat, yPosition: CGFloat)  {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = shooter.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = aliencategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        if shooter === player {
            torpedoNode.name = "Player1Torpedo"
        } else if shooter === player2 {
            torpedoNode.name = "Player2Torpedo"
        }
        
        
        self.addChild(torpedoNode)
        
        let animationDuration: TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: xPosition, y: yPosition), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:  SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
//        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & aliencategory) != 0 {
//            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
//        }
        
        if firstBody.node?.name == "Player1Torpedo" && secondBody.node?.name == "Alien" {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode, torpedoName: (firstBody.node?.name)!)
        } else if firstBody.node?.name == "Player2Torpedo" && secondBody.node?.name == "Alien" {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode, torpedoName: (firstBody.node?.name)!)
        }
    }
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode, torpedoName: String){
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
//        score += 5
//        score2 += 5
        if torpedoName == "Player1Torpedo" {
            score += 5
        } else if torpedoName == "Player2Torpedo" {
            score2 += 5
        }
        
        if (score >= 100) {
            
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true, imgName: "shuttle")
            self.view?.presentScene(gameOverScene, transition: reveal)
            
        }else if (score2 >= 100) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true, imgName: "shuttle-2")
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

