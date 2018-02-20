//
//  GameOverScene.swift
//  SpaceWarriorMani
//
//  Created by Mandeep Panesar on 2018-02-05.
//  Copyright © 2018 Lambton. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    
    
    var quitButton = SKSpriteNode()
    let quitButtonTex = SKTexture(imageNamed: "quit")
    
    var replayButton = SKSpriteNode()
    let replayButtonTex = SKTexture(imageNamed: "replay")
    var playerSprite : SKSpriteNode!
    
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = won ? "You Won!" : "You Lose!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 60)
        addChild(label)
    }
    
    init(size: CGSize, won:Bool, imgName: String) {
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = won ? "You Won!" : "You Lose!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 60)
        addChild(label)
        
        playerSprite = SKSpriteNode(imageNamed: imgName)
        playerSprite.position = CGPoint(x: size.width/2, y: size.height/2 + 220)
        playerSprite.size = CGSize(width: 200.0, height: 200.0)
        addChild(playerSprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        quitButton = SKSpriteNode(texture: quitButtonTex)
        quitButton.position = CGPoint(x: frame.midX, y: frame.midY - 10)
        quitButton.size = CGSize(width: 70.0, height: 70.0)
        self.addChild(quitButton)
        
        replayButton = SKSpriteNode(texture: replayButtonTex)
        replayButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        replayButton.size = CGSize(width: 70.0, height: 70.0)
        self.addChild(replayButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == quitButton {
                exit(0)
            }else if node == replayButton{
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = MenuScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
}
