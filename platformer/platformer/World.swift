//
//  World.swift
//  Micronaut
//
//  Created by Christopher Williams on 1/16/16.
//  Copyright © 2016 Christopher Williams. All rights reserved.
//
//  Contains all sprites within the world.

import Foundation
import SpriteKit

class World {
    static var ShouldReset:Bool = false
    static var Level:Int = 0
    
    static private var sprites:[String:SKNode] = [String:SKNode]()
    
    class func initialize(scene: SKScene) {
        loadSprites(scene)
    }
    
    // Adding "//" searches for nodes recursively https://developer.apple.com/library/ios/documentation/SpriteKit/Reference/SKNode_Ref/index.html#//apple_ref/occ/cl/SKNode
    class func loadSprites(scene: SKScene) {
        sprites[Constants.Node_Player] = scene.childNodeWithName("//\(Constants.Node_Player)")!
        sprites[Constants.Node_Camera] = scene.childNodeWithName("//\(Constants.Node_Camera)")!
        sprites[Constants.Node_Boss] = scene.childNodeWithName("//\(Constants.Node_Boss)")!
        sprites[Constants.Node_Congrats] = scene.childNodeWithName("//\(Constants.Node_Congrats)")!
        sprites[Constants.Node_Congrats]?.hidden = true
        // Load background nodes
        for name in Constants.Node_BG {
            sprites[name] = scene.childNodeWithName("//\(name)")!
        }
        // Load goal nodes
        for name in Constants.Node_Goals {
            sprites[name] = scene.childNodeWithName("//\(name)")!
        }
        // Shift physics body of ground down and reduce bottom by 10 px
        let diff:CGFloat = -8
        for name in Constants.Node_LV {
            let node = scene.childNodeWithName("//\(name)")!
            node.enumerateChildNodesWithName("ground", usingBlock: {
                (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                let physics = SKPhysicsBody(rectangleOfSize: CGSizeMake(64, 80+diff), center: CGPoint(x: 0, y: diff))
                physics.dynamic = false
                physics.allowsRotation = false
                physics.pinned = true
                physics.affectedByGravity = false
                physics.categoryBitMask = Constants.CollisionCategory_Ground
                physics.contactTestBitMask = Constants.CollisionCategory_Player
                node.physicsBody = physics
            })
            node.enumerateChildNodesWithName("edge", usingBlock: {
                (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                let physics = SKPhysicsBody(rectangleOfSize: CGSizeMake(64, 80+diff), center: CGPoint(x: 0, y: diff))
                physics.dynamic = false
                physics.allowsRotation = false
                physics.pinned = true
                physics.affectedByGravity = false
                physics.categoryBitMask = Constants.CollisionCategory_Ground
                physics.contactTestBitMask = Constants.CollisionCategory_Player
                node.physicsBody = physics
            })
        }
    }
    
    class func getSpriteByName(name: String) -> SKNode {
        return sprites[name]!
    }

    // Player either died or acheived the goal. Reset the sprites.
    class func reset() {
        Boss.reset()
        Player.reset()

//        for name in Constants.Node_BG {
//            World.getSpriteByName(name).position.x = 0.0
//        }
        
        World.ShouldReset = false
    }
    
    // Gets called with every frame.
    class func update() {
        // Check if we need to reset the world
        if World.ShouldReset {
            World.reset()
        }
    }
    
    class func nextLevel() {
        // Increment the level or loop back to the beginning
        // If statement checks to make sure a goal isn't registered twice
        if (World.ShouldReset == false) {
            World.Level = (World.Level + 1) % World.numLevels()
            World.ShouldReset = true
        }
        // Stop the player's velocity
        Player.setVelocityX(0.0, force: true)
        // Use the next level's background texture
//        let background = (World.getSpriteByName(Constants.Node_Background) as! SKSpriteNode)
//        background.texture = SKTexture(imageNamed: "bg-\(World.Level)")
        // Special conditions for specific level
        if World.Level == World.numLevels() - 1 {
            // Play ominous music if last/boss level
            Sound.play("ominous.wav", loop: false)
        }
        else if World.Level == 0 {
            // Completed the game!
            World.displayCongrats()
//        } else {
//            World.hideCongrats()
        }
    }
    
    class func displayCongrats() {
        let congrats = World.getSpriteByName(Constants.Node_Congrats)
        congrats.hidden = false
    }
    
    class func hideCongrats() {
        let congrats = World.getSpriteByName(Constants.Node_Congrats)
        congrats.hidden = true
    }
    
    class func numLevels() -> Int {
        return Constants.LevelSpawnPoints.count
    }
}