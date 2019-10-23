//
//  Game2.swift
//  Prj
//
//  Created by Aldo D'Orso on 19/10/2019.
//  Copyright © 2019 Aldo D'Orso. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Game2: SKScene,SKPhysicsContactDelegate {
    var floor, mare, btnBack, marino, reef, bodyMare, cestino, imm, ogg, pause : SKSpriteNode!
    var nomeCestino, puntiLabel, back, label : SKLabelNode!
    var timerNemici, timerMare : Timer!
    var indiceMare : Int = 0
    var font = "Noteworthy"
    var barriera, barriera2 : SKSpriteNode!
    var state = 1
    var oggCategoriMask : UInt32 = 0x1 << 1
    var cestCategoryMask : UInt32 = 0x1 << 2
    var immCategoryMask : UInt32 = 0x1 << 3
    var mareCategoryMask : UInt32 = 0x1 << 4
    
    var punteggio = 0{
        didSet{
            puntiLabel.text = "Score : \(punteggio)"
            if punteggio % 10 == 0{
                let arrayDiFiori : [UIImage] = [#imageLiteral(resourceName: "stellamarina 5"),#imageLiteral(resourceName: "conciglie 5"),#imageLiteral(resourceName: "conciglie"),#imageLiteral(resourceName: "stellamarina"),#imageLiteral(resourceName: "alge")]
                let randomX = GKRandomDistribution(lowestValue: 0, highestValue: 828)
                let randomY = GKRandomDistribution(lowestValue: 130, highestValue: 300)
                marino = SKSpriteNode()
                marino.texture = SKTexture(image: arrayDiFiori[Int.random(in: 0..<arrayDiFiori.count)])
                marino.size = CGSize(width: 50, height: 50)
                marino.position = CGPoint(x: randomX.nextInt(), y: randomY.nextInt())
                marino.zPosition = floor.zPosition + 1
                addChild(marino)
            }
        }
    }
    var modalitaDark : Bool = false{
        didSet {
            if oldValue == false && modalitaDark == true {
                let darkMode = SKSpriteNode()
                darkMode.name = "DarkON"
                darkMode.color = .black
                darkMode.alpha = 0.2
                darkMode.position = CGPoint(x: self.frame.width, y: self.frame.height)
                darkMode.size = CGSize(width: 5000, height: 5000)
                darkMode.zPosition = 20
                self.addChild(darkMode)
            }
            if oldValue == true && modalitaDark == false{
                for n in children{
                    if n.name == "DarkON"{
                        n.removeFromParent()
                    }
                }
            }
        }
    }
    var vite = 5 {
        didSet{
            if vite == 0{
                timerNemici.invalidate()
                label.text = "Game Over"
                label.isHidden = false
            }
            for n in children{
                if n.name == "vita\(vite)"{
                    n.removeFromParent()
                }
            }
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    func creaBarriere() {
        
        barriera = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 1, height: 743))
        barriera.position = CGPoint(x: -7, y: 1420)
        barriera.physicsBody = SKPhysicsBody(rectangleOf: barriera.size)
        barriera.physicsBody?.isDynamic = false
        barriera.physicsBody?.affectedByGravity = false
        
        addChild(barriera)
        
        barriera2 = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 1, height: 743))
        barriera2.position = CGPoint(x: 830, y: 1420)
        barriera2.physicsBody = SKPhysicsBody(rectangleOf: barriera.size)
        barriera2.physicsBody?.isDynamic = false
        barriera2.physicsBody?.affectedByGravity = false
        
        addChild(barriera2)
        
    }
    override func didMove(to view: SKView) {
        
        backgroundColor = .blue
        
        label = SKLabelNode(text: "Pause")
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2+300)
        label.fontColor = UIColor.yellow
        label.fontSize = 100
        label.fontName = font
        label.isHidden = true
        
        nomeCestino = SKLabelNode(text: "Plastic")
        nomeCestino.fontName = font
        nomeCestino.fontSize = 28
        nomeCestino.fontColor = UIColor.black
        nomeCestino.position = CGPoint(x: 693, y: 875)
        nomeCestino.zPosition = 10
        
        back = SKLabelNode(text: "Back")
        back.fontName = font
        back.fontSize = 32
        back.fontColor = UIColor.white
        back.position = CGPoint(x: 154, y: 1685)
        
        bodyMare = SKSpriteNode()
        bodyMare.color = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        bodyMare.position = CGPoint(x: 279, y: 500)
        bodyMare.size = CGSize(width: 1058, height: 370)
        bodyMare.zRotation = 0.03
        bodyMare.physicsBody = SKPhysicsBody(rectangleOf: bodyMare.size)
        bodyMare.physicsBody?.isDynamic = false
        bodyMare.physicsBody?.affectedByGravity = false
        bodyMare.physicsBody?.restitution = 0.3
        bodyMare.physicsBody?.categoryBitMask = mareCategoryMask
        bodyMare.physicsBody?.collisionBitMask = immCategoryMask
        
        
        btnBack = SKSpriteNode()
        btnBack.texture = SKTexture(image: #imageLiteral(resourceName: "Untitled"))
        btnBack.position = CGPoint(x: 78, y: 1707)
        btnBack.size = CGSize(width: 38, height: 72)
        btnBack.zPosition = 11
        
        mare = SKSpriteNode()
        mare.position = CGPoint(x: 279, y: 580)
        mare.size = CGSize(width: 558, height: 634)
        mare.zPosition = 1
        
        floor = SKSpriteNode()
        floor.texture = SKTexture(image: #imageLiteral(resourceName: "GrassJoinHillLeft"))
        floor.position = CGPoint(x: 414, y: 31)
        floor.size = CGSize(width: 828, height: 467)
        floor.zPosition = mare.zPosition+1
        
        reef = SKSpriteNode()
        reef.texture = SKTexture(image: #imageLiteral(resourceName: "GrassJoinHillLeft"))
        reef.position = CGPoint(x: 693, y: 580)
        reef.size = CGSize(width: 269, height: 630)
        reef.zPosition = floor.zPosition - 1
        
        puntiLabel = SKLabelNode()
        puntiLabel.text = "Punteggio: "
        puntiLabel.fontName = font
        puntiLabel.position = CGPoint(x: 150, y: 100)
        puntiLabel.fontSize = 40
        puntiLabel.zPosition = 11
        puntiLabel.fontColor = UIColor.black
        puntiLabel.zPosition = floor.zPosition+6
        
        cestino = SKSpriteNode()
        cestino.name = "cestino"
        cestino.texture = SKTexture(image: #imageLiteral(resourceName: "monnezza"))
        cestino.size = CGSize(width: 160, height: 159)
        cestino.zPosition = floor.zPosition+1
        cestino.position = CGPoint(x: 693, y: 921)
        
        
        cestino.physicsBody = SKPhysicsBody(rectangleOf: cestino.size)
        cestino.physicsBody?.affectedByGravity = false
        cestino.physicsBody?.isDynamic = false
        cestino.physicsBody?.categoryBitMask = cestCategoryMask
        cestino.physicsBody?.contactTestBitMask = immCategoryMask
        
        
        ogg = SKSpriteNode()
        ogg.name = "ogg"
        ogg.texture = SKTexture(image: #imageLiteral(resourceName: "stella"))
        ogg.size = CGSize(width: 120, height: 120)
        ogg.position = CGPoint(x: 500, y: 500)
        ogg.zPosition = floor.zPosition+19
        ogg.physicsBody = SKPhysicsBody(circleOfRadius: ogg.size.width/2)
        ogg.physicsBody?.contactTestBitMask = 1
        ogg.physicsBody?.restitution = 0.3
        ogg.physicsBody?.isDynamic = false
        ogg.physicsBody?.affectedByGravity = false
        ogg.physicsBody?.contactTestBitMask = immCategoryMask
        
        timerNemici = Timer.scheduledTimer(timeInterval: 2.1 , target: self, selector: #selector(creaNemici), userInfo: nil, repeats: true)
        timerMare = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(muoviMare), userInfo: nil, repeats: true)
        physicsWorld.contactDelegate = self
        
        pause = SKSpriteNode()
        pause.texture = SKTexture(image: #imageLiteral(resourceName: "pause"))
        pause.position = CGPoint(x: 778, y: 1707)
        pause.size = CGSize (width: 38, height: 62)
        pause.zPosition = 11
        
        creaNemici()
        addChild(label)
        addChild(pause)
        addChild(nomeCestino)
        addChild(back)
        addChild(btnBack)
        addChild(mare)
        addChild(floor)
        addChild(cestino)
        addChild(ogg)
        addChild(reef)
        addChild(puntiLabel)
        addChild(bodyMare)
        mostraVite(lives: vite)
        creaBarriere()
    }
    
    
    @objc func muoviMare(){
        let mari : [UIImage] = [#imageLiteral(resourceName: "image 1"),#imageLiteral(resourceName: "image 2"),#imageLiteral(resourceName: "image 3"),#imageLiteral(resourceName: "image 4"),#imageLiteral(resourceName: "image 5"),#imageLiteral(resourceName: "image 6"),#imageLiteral(resourceName: "image 7"),#imageLiteral(resourceName: "image 8"),#imageLiteral(resourceName: "image 9"),#imageLiteral(resourceName: "image 10"),#imageLiteral(resourceName: "image 11"),#imageLiteral(resourceName: "image 12"),#imageLiteral(resourceName: "image 13"),#imageLiteral(resourceName: "image 14"),#imageLiteral(resourceName: "image 15"),#imageLiteral(resourceName: "image 16"),#imageLiteral(resourceName: "image 17")]
        mare.texture = SKTexture(image: mari[indiceMare])
        indiceMare = indiceMare + 1
        indiceMare %= mari.count
        
    }
    @objc func creaNemici(){
        
        let randomX = GKRandomDistribution(lowestValue: 0, highestValue: 500)
        let randomY = GKRandomDistribution(lowestValue: 1840, highestValue: 1900)

        
        imm = SKSpriteNode()
        imm.name = "imm"
        imm.texture = SKTexture(image: #imageLiteral(resourceName: "garbage")) // TODO non coerente Warning
        imm.size = CGSize(width: 120, height: 120)
        imm.position = CGPoint(x: randomX.nextInt(), y: randomY.nextInt())
        imm.zPosition = 2
        imm.physicsBody = SKPhysicsBody(circleOfRadius: imm.size.width/2)
        imm.physicsBody?.affectedByGravity = true
        imm.physicsBody?.restitution = 0.3
        imm.physicsBody?.categoryBitMask = immCategoryMask
        addChild(imm)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        ogg.position = location
    }
    func mostraVite (lives : Int){
        let spaziatura = 50
        for i in 0..<lives {
            let vita = SKSpriteNode()
            vita.texture = SKTexture(image: #imageLiteral(resourceName: "vita"))
            vita.name = "vita\(i)"
            vita.size = CGSize(width: 50, height: 50)
            vita.position = CGPoint(x: 798 - (i*spaziatura), y: 1607)
            addChild(vita)
        }
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            let l = t.location(in: self)
            
            if btnBack.contains(l){
                run(SKAction.run {
                    (self.view?.presentScene(GameScene(size: self.size), transition: SKTransition.fade(withDuration: 0.8)))!
                    
                })
            }
            if pause.contains(l){
                if state == 1{
                    timerNemici.invalidate()
                    self.view?.isPaused = true
                    state = 0
                    label.isHidden = false
                }
                else {
                    timerNemici = Timer.scheduledTimer(timeInterval: 2.1 , target: self, selector: #selector(creaNemici), userInfo: nil, repeats: true)
                    self.view?.isPaused = false
                    state = 1
                    label.isHidden = true
                }
            }
        
        }
    }
    override func update(_ currentTime: TimeInterval) {
        for n in children{
            if n.position.x < -12{
                n.removeFromParent()
                vite -= 1
            }
        }
        if GameViewController.darkmode == true{
            modalitaDark = true
        }
        else{
            modalitaDark = false
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
    
        if contact.bodyA.node?.name == "cestino" && contact.bodyB.node?.name == "imm"{
            contact.bodyB.node?.removeFromParent()
            punteggio += 1
        }
        
        if contact.bodyA.node?.name == "ogg" && contact.bodyB.node?.name == "imm"{
            contact.bodyB.node?.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 300))
            punteggio += 1
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
