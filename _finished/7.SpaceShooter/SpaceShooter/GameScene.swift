//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Ben Scheirman on 10/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import SpriteKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerVelocity: CGPoint = .zero
    
    var player: SKNode!
    var thrusters: SKEmitterNode!
    
    var missiles: Set<SKNode> = []
    
    let boundaryCategory: UInt32 = 0x1 << 1
    let missileCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "Player")
        let ref = player.childNode(withName: "Thrusters") as? SKReferenceNode
        thrusters = ref!.children.first! as! SKEmitterNode
        thrusters.targetNode = self
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.insetBy(dx: -100, dy: -800))
        physicsBody?.categoryBitMask = boundaryCategory
        physicsWorld.contactDelegate = self
        
        listenForControllers()
        hookUpControllers()
    }
    
    func listenForControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.controllerConnected(_:)), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.controllerDisconnected(_:)), name: .GCControllerDidDisconnect, object: nil)
    }
    
    func controllerConnected(_ notification: NSNotification) {
        print("Controller connected...")
        hookUp(controller: notification.object as! GCController)
    }
    
    func controllerDisconnected(_ notification: NSNotification) {
        print("Controller disconnected")
    }
    
    func hookUpControllers() {
        for controller in GCController.controllers() {
            hookUp(controller: controller)
        }
    }
    
    func hookUp(controller: GCController) {
        
        print("Setting up \(controller.vendorName)")
        controller.microGamepad?.dpad.valueChangedHandler = { dpad, x, y in
            self.playerVelocity.x += CGFloat(x)
            self.playerVelocity.y += CGFloat(y)
        }
        
        controller.microGamepad?.buttonA.pressedChangedHandler = { _, _, isPressed in
            if isPressed {
                self.fireMissile()
            }
        }
        
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = { axis, x, y in
            self.playerVelocity.x = CGFloat(x * 10)
            self.playerVelocity.y = CGFloat(y * 10)
        }
    }
    
    func fireMissile() {
        let missile = SKSpriteNode(imageNamed: "spaceMissiles_001")
        missile.position = CGPoint(x: player.position.x, y: player.position.y + 50)
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.texture!.size())
        missile.physicsBody?.mass = 1
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody?.categoryBitMask = missileCategory
        missile.physicsBody?.contactTestBitMask = boundaryCategory
        addChild(missile)
        
        missile.physicsBody!.velocity = CGVector(dx: playerVelocity.x * 2, dy: 0)
        missile.physicsBody!.applyImpulse(CGVector(dx: playerVelocity.x * 2, dy: 100))
        
        let soundAction = SKAction.playSoundFileNamed("missile.wav", waitForCompletion: false)
        missile.run(soundAction)
        
        let emitter = SKEmitterNode(fileNamed: "MissileTrails")!
        emitter.targetNode = self
        
        missile.addChild(emitter)
        
        missiles.insert(missile)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var pos = player.position
        pos.x += playerVelocity.x
        pos.y += playerVelocity.y

        let leftEdge = -anchorPoint.x * size.width
        let rightEdge = anchorPoint.x * size.width
        let bottomEdge = anchorPoint.y * size.height
        let topEdge = -anchorPoint.y * size.height
        
        if pos.x < leftEdge {
            playerVelocity.x = 0
            pos.x = leftEdge
        } else if pos.x > rightEdge {
            playerVelocity.x = 0
            pos.x = rightEdge
        }
        
        if pos.y < topEdge {
            pos.y = topEdge
            playerVelocity.y = 0
        } else if pos.y > bottomEdge {
            pos.y = bottomEdge
            playerVelocity.y = 0
        }
        
        player.position = pos
        
        for m in missiles {
            m.physicsBody?.applyForce(CGVector(dx: 0, dy: 500))
            
            print("m.position.y: \(m.position.y) -- top edge \(topEdge)  bottom edge \(bottomEdge)")
            if m.position.y < topEdge {
                missiles.remove(m)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == boundaryCategory || contact.bodyB.categoryBitMask == boundaryCategory &&
            contact.bodyA.categoryBitMask == missileCategory || contact.bodyB.categoryBitMask == missileCategory {
            
            let missileNode: SKNode
            if contact.bodyA.categoryBitMask == missileCategory {
                missileNode = contact.bodyA.node!
            } else {
                missileNode = contact.bodyB.node!
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                print("timeout, removing missile")
                self.missiles.remove(missileNode)
                missileNode.removeFromParent()
            })
        }
    }
}
