//
//  GameScene.swift
//  Micronaut
//
//  Created by Christopher Williams on 10/18/15.
//  Copyright (c) 2015 Christopher Williams. All rights reserved.
//
//  The head hancho file that handles everything.

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        World.loadSprites(self)
        Controller.loadGestures(view)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        Controller.update()
        
        // If the player fell, bring them back to start
        if World.getPlayer().position.y < 0.0 {
            World.getPlayer().position = CGPointMake(128, 768)
            World.getBackground().position = CGPointMake(0, 0)
        }
        
        // Background horizontal parallax motion
        World.getBackground().position.x += -0.01 * World.getPlayer().physicsBody!.velocity.dx
    }
    
    override func didFinishUpdate() {
        // Keep the camera's x-position focused on player
        World.getCamera().position.x = World.getPlayer().position.x
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Controller.touchBegan((touches.first?.locationInView(self.view))!)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Controller.touchMoved((touches.first?.locationInView(self.view))!)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Controller.touchEnded()
    }
}
