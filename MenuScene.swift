//
//  MenuScene.swift
//  SpaceWarriorMani
//
//  Created by Mandeep Panesar on 2018-02-04.
//  Copyright © 2018 Lambton. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    
    var vsButton = SKSpriteNode()
    let vsButtonTex = SKTexture(imageNamed: "vs")
    
    override func didMove(to view: SKView) {
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        playButton.size = CGSize(width: 70.0, height: 70.0)
        self.addChild(playButton)
        
        vsButton = SKSpriteNode(texture: vsButtonTex)
        vsButton.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        vsButton.size = CGSize(width: 70.0, height: 70.0)
        self.addChild(vsButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }else if node == vsButton{
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = MultiPlayerGameScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
