//
//  GameScene.swift
//  WhackPenguin
//
//  Created by Alexey Meleshkevich on 15.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var popupTime = 0.85
    var gameScore: SKLabelNode!
    var numRounds = 0
    
    var score = 0 {
        didSet(score) {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
        }
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
        }
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
        }
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if !whackSlot.isVisible { continue }
            if whackSlot.isHitted { continue }
            
            whackSlot.hit()
            
            if node.name == "good" {
                
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad", waitForCompletion: false))
            } else if node.name == "bad" {
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            run(SKAction.playSoundFileNamed("Первомайская-улица", waitForCompletion: true))
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let scoreFinal = SKLabelNode(text: "Your final score: \(score)")
            scoreFinal.position = CGPoint(x: 512, y: 200)
            scoreFinal.fontName = "Chalkduster"
            scoreFinal.fontSize = 48
            scoreFinal.zPosition = 1
            addChild(scoreFinal)
            
            return
            
            
        }
        popupTime *= 0.991
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        let smokeParticles = SKEmitterNode(fileNamed: "smokeLil")
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
            smokeParticles?.position = slots[1].position
            addChild(smokeParticles!)
        }
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popupTime)
            smokeParticles?.position = slots[2].position
            addChild(smokeParticles!)
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popupTime)
            smokeParticles?.position = slots[3].position
            addChild(smokeParticles!)
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popupTime)
            smokeParticles?.position = slots[4].position
            addChild(smokeParticles!)
        }
        
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
