//
//  GameScene.swift
//  Pachinko
//
//  Created by Alexey Meleshkevich on 14.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballsNames = ["ballRed","ballCyan","ballGreen","ballGrey","ballPurple","ballRed","ballYellow"]
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet(newScore) {
            scoreLabel.text = "Score: \(String(newScore))"
        }
    }
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
                
            } else {
                let ballColor = Int.random(in: 0...6)
                let ballNode = SKSpriteNode(imageNamed: ballsNames[ballColor])
                ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width / 2.0)
                ballNode.physicsBody?.restitution = 0.4
                ballNode.position.x = location.x
                ballNode.position.y = scene?.frame.height ?? location.y
                ballNode.physicsBody?.contactTestBitMask = ballNode.physicsBody?.collisionBitMask ?? 0
                ballNode.name = "ball"
                addChild(ballNode)
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncedNode = SKSpriteNode(imageNamed: "bouncer")
        bouncedNode.position = position
        bouncedNode.physicsBody = SKPhysicsBody(circleOfRadius: bouncedNode.frame.size.width / 2.0)
        bouncedNode.physicsBody?.isDynamic = false
        addChild(bouncedNode)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBaseNode: SKSpriteNode
        var slotGlowNode: SKSpriteNode
        
        if isGood {
            slotBaseNode = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlowNode = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBaseNode.name = "good"
        } else {
            slotBaseNode = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlowNode = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBaseNode.name = "bad"
        }
        
        slotBaseNode.position = position
        slotGlowNode.position = position

        addChild(slotBaseNode)
        addChild(slotGlowNode)
        
        slotBaseNode.physicsBody = SKPhysicsBody(rectangleOf: slotBaseNode.size)
        slotBaseNode.physicsBody?.isDynamic = false
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 20)
        let spinForever = SKAction.repeatForever(spin)
        slotGlowNode.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball"  {
            collision(between: nodeB, object: nodeA)
        }
    }
}
