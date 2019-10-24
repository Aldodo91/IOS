//
//  Game3.swift
//  Prj
//
//  Created by Ernesto Di Ruocco on 22/10/2019.
//  Copyright © 2019 Aldo D'Orso. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import GameplayKit

enum GameState {
    case playing
    case menu
    static var current = GameState.playing
}

struct pc { //Physics Category
    static let none: UInt32 = 0x1 << 0
    static let ball: UInt32 = 0x1 << 1
    static let lBin: UInt32 = 0x1 << 2
    static let rBin: UInt32 = 0x1 << 3
    static let base: UInt32 = 0x1 << 4
    static let sG: UInt32 = 0x1 << 5
    static let eG: UInt32 = 0x1 << 6
}

struct t { //Start and End touch point
    static var start = CGPoint()
    static var end = CGPoint()
}

struct c { // Constants
    static var grav = CGFloat() // Gravity
    static var yVel = CGFloat()    // Initial Y Velocity
    static var airTime = TimeInterval() // Time the ball is in the air
}

class Game3: SKScene, SKPhysicsContactDelegate {

    // Variables
    
    var grids = false   // turn on to see all the physics grid lines
    
    // SKSprites
    var bg = SKSpriteNode(imageNamed: "background")        // background image
    var bFront = SKSpriteNode(imageNamed: "binverde")   // Front portion of the bin
    var pBall = SKSpriteNode(imageNamed: "vetro")  // Paper Ball skin
    
    var orologio = SKSpriteNode(imageNamed: "orologio")
    var bin2Label : SKLabelNode!
    var font = "Noteworthy"
    
    var btnBack, imm : SKSpriteNode!
    
    //SKShapes
    var ball = SKShapeNode()
    var leftWall = SKShapeNode()
    var rightWall = SKShapeNode()
    var base = SKShapeNode()
    var endG = SKShapeNode()    // The ground that the bin will sit on
    var startG = SKShapeNode()  // Where the paper ball will start
    
    // SKLabels
    var windLbl = SKLabelNode()
    
    // CGFloats
    var pi = CGFloat(Double.pi)
    var wind = CGFloat()
    
    var touchingBall = false
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
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    
    
     // Did Move To View - The GameViewController.swift has now displayed GameScene.swift and will instantly run this function.
        override func didMove(to view: SKView) {
            self.physicsWorld.contactDelegate = self
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                c.grav = -6
                c.yVel = 3 * self.frame.height / 4
                c.airTime = 1.5
            }else{
                // iPad
            }
            
            physicsWorld.gravity = CGVector(dx: 0, dy: c.grav)
            
            setUpGame()
        }
        
        // Fires the instant a touch has made contact with the screen
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if GameState.current == .playing {
                    if ball.contains(location){
                        t.start = location
                        touchingBall = true
                    }
                }
                if btnBack.contains(location){
                    run(SKAction.run {
                        (self.view?.presentScene(GameScene(size: self.size), transition: SKTransition.fade(withDuration: 0.8)))!
                        
                    })
                }
            }
        }
        
        // Fires as soon as the touch leaves the screen
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if GameState.current == .playing && !ball.contains(location) && touchingBall{
                    t.end = location
                    touchingBall = false
                    fire()
                }
            }
        }
        
        // Set the images and physics properties of the GameScene
        func setUpGame() {
            GameState.current = .playing
            
            // Background
            let bgScale = CGFloat(bg.frame.width / bg.frame.height) // eg. 1.4 as a scale
            
            bg.size.height = self.frame.height
            bg.size.width = bg.size.height * bgScale
            bg.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            bg.zPosition = 0
            self.addChild(bg)
            
            // secchio
            let binScale = CGFloat(bFront.frame.width / bFront.frame.height)

            bFront.size.height = self.frame.height / 5
            bFront.size.width = bFront.size.height * binScale
            bFront.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 3.3)
            bFront.zPosition = 4
            self.addChild(bFront)
            
            //orologio
            orologio.size = CGSize(width: 250, height: 250)
            orologio.zPosition = bg.zPosition + 1
            orologio.position = CGPoint(x: 430, y: 1550)
            addChild(orologio)
            
            
            //bin2Label
            bin2Label = SKLabelNode(text: "GLASS")
            bin2Label.fontName = font
            bin2Label.fontSize = 35
            bin2Label.fontColor = UIColor.black
            bin2Label.position = CGPoint(x: 415, y: 420)
            bin2Label.zPosition = 15
            addChild(bin2Label)
              
          // bottone back
              btnBack = SKSpriteNode()
              btnBack.texture = SKTexture(image: #imageLiteral(resourceName: "btnVerde"))
              btnBack.position = CGPoint(x: 78, y: 1707)
              btnBack.size = CGSize(width: 38, height: 72)
              btnBack.zPosition = bg.zPosition + 1
              addChild(btnBack)
            
            
            // Start ground - make grids true at the top to see these lines
            startG = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: 5))
            startG.fillColor = .red
            startG.strokeColor = .clear
            startG.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 10)
            startG.zPosition = 10
            startG.alpha = grids ? 1 : 0
            
            startG.physicsBody = SKPhysicsBody(rectangleOf: startG.frame.size)
            startG.physicsBody?.categoryBitMask = pc.sG
            startG.physicsBody?.collisionBitMask = pc.ball
            startG.physicsBody?.contactTestBitMask = pc.none
            startG.physicsBody?.affectedByGravity = false
            startG.physicsBody?.isDynamic = false
            self.addChild(startG)
            
            // End ground
            endG = SKShapeNode(rectOf: CGSize(width: self.frame.width * 2, height: 5))
            endG.fillColor = .red
            endG.strokeColor = .clear
            endG.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 3 - bFront.frame.height / 2)
            endG.zPosition = 10
            endG.alpha = grids ? 1 : 0
            
            endG.physicsBody = SKPhysicsBody(rectangleOf: endG.frame.size)
            endG.physicsBody?.categoryBitMask = pc.eG
            endG.physicsBody?.collisionBitMask = pc.ball
            endG.physicsBody?.contactTestBitMask = pc.none
            endG.physicsBody?.affectedByGravity = false
            endG.physicsBody?.isDynamic = false
            self.addChild(endG)
            
            // Left Wall of the bin
            leftWall = SKShapeNode(rectOf: CGSize(width: 3, height: bFront.frame.height / 1.1))
            leftWall.fillColor = .red
            leftWall.strokeColor = .clear
            leftWall.position = CGPoint(x: bFront.position.x - bFront.frame.width / 3, y: bFront.position.y)
            leftWall.zPosition = 10
            leftWall.alpha = grids ? 1 : 0
        
            leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.frame.size)
//            print ("leftWall.frame.size" , leftWall.frame.size.height)
            
            leftWall.physicsBody?.categoryBitMask = pc.lBin
            leftWall.physicsBody?.collisionBitMask = pc.ball
            leftWall.physicsBody?.contactTestBitMask = pc.none
            leftWall.physicsBody?.affectedByGravity = false
            leftWall.physicsBody?.isDynamic = false
            leftWall.zRotation = pi / 25
            self.addChild(leftWall)
            
            // Right wall of the bin
            rightWall = SKShapeNode(rectOf: CGSize(width: 3, height: bFront.frame.height / 1.1))
            rightWall.fillColor = .red
            rightWall.strokeColor = .clear
            rightWall.position = CGPoint(x: bFront.position.x + bFront.frame.width / 3.2, y: bFront.position.y)
            rightWall.zPosition = 10
            rightWall.alpha = grids ? 1 : 0
            
            rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.frame.size)
            rightWall.physicsBody?.categoryBitMask = pc.rBin
            rightWall.physicsBody?.collisionBitMask = pc.ball
            rightWall.physicsBody?.contactTestBitMask = pc.none
            rightWall.physicsBody?.affectedByGravity = false
            rightWall.physicsBody?.isDynamic = false
            rightWall.zRotation = -pi / 25
            self.addChild(rightWall)
            
            // The base of the bin
            base = SKShapeNode(rectOf: CGSize(width: bFront.frame.width / 2, height: 3))
            base.fillColor = .red
            base.strokeColor = .clear
            base.position = CGPoint(x: bFront.position.x, y: bFront.position.y - bFront.frame.height / 4)
            base.zPosition = 10
            base.alpha = grids ? 1 : 0
            base.physicsBody = SKPhysicsBody(rectangleOf: base.frame.size)
            base.physicsBody?.categoryBitMask = pc.base
            base.physicsBody?.collisionBitMask = pc.ball
            base.physicsBody?.contactTestBitMask = pc.ball
            base.physicsBody?.affectedByGravity = false
            base.physicsBody?.isDynamic = false
            self.addChild(base)
            
            // The wind label
            windLbl.text = "Wind = 0"
            windLbl.fontName = font
            windLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 4 / 9.2)
            windLbl.fontSize = self.frame.width / 15
            windLbl.fontColor = UIColor.black
            windLbl.zPosition = bg.zPosition + 1
            self.addChild(windLbl)

            setWind()
            setBall()
        }
        
        // Set up the ball. This will be called to reset the ball too
        func setBall() {
            
            // Remove and reset incase the ball was previously thrown
            pBall.removeFromParent()
            ball.removeFromParent()
            
            ball.setScale(1)
            
            // Set up ball
            ball = SKShapeNode(circleOfRadius: bFront.frame.width / 3.5)
            ball.fillColor = grids ? .blue : .clear
            ball.strokeColor = .clear
            ball.position = CGPoint(x: self.frame.width / 2, y: startG.position.y + ball.frame.height)
            ball.zPosition = 10
            
            // Add "paper skin" to the circle shape
//            pBall.size = ball.frame.size
            pBall.size = CGSize(width: 380, height: 380)
            ball.addChild(pBall)
            
            // Set up the balls physics properties
            ball.physicsBody = SKPhysicsBody(circleOfRadius: pBall.size.width/4)
            ball.physicsBody?.categoryBitMask = pc.ball
            ball.physicsBody?.collisionBitMask = pc.sG
            ball.physicsBody?.contactTestBitMask = pc.base
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.isDynamic = true
            self.addChild(ball)
        }
        
        // Fetch a new wind speed and store it for use on the ball
        func setWind() {
            let multi = CGFloat(50)
            let rnd = CGFloat(arc4random_uniform(UInt32(10))) - 5

            windLbl.text = "Wind: \(rnd)"
            wind = rnd * multi
        }
        
        // When touches ended this is called to shoot the paper ball
        func fire() {
            
            let xChange = t.end.x - t.start.x
            let angle = (atan(xChange / (t.end.y - t.start.y)) * 180 / pi)
            let amendedX = (tan(angle * pi / 180) * c.yVel) * 1.5
            
            // Throw it!
            let throwVec = CGVector(dx: amendedX, dy: c.yVel)
            ball.physicsBody?.applyImpulse(throwVec, at: t.start)
            
            // Shrink
            ball.run(SKAction.scale(by: 0.3, duration: c.airTime))
            
            // Change Collision Bitmask
            let wait = SKAction.wait(forDuration: c.airTime / 2)
            let changeCollision = SKAction.run({
                self.ball.physicsBody?.collisionBitMask = pc.sG | pc.eG | pc.base | pc.lBin | pc.rBin
                self.ball.zPosition = self.bg.zPosition + 2
            })
            
            // ADD WIND STEVE!
            let windWait = SKAction.wait(forDuration: c.airTime / 4)
            let push = SKAction.applyImpulse(CGVector(dx: wind, dy: 0), duration: 1)
            ball.run(SKAction.sequence([windWait, push]))
            self.run(SKAction.sequence([wait,changeCollision]))
            
            // Wait & reset
            let wait4 = SKAction.wait(forDuration: 4)
            let reset = SKAction.run({
//                self.setWind()
                self.setBall()
            })
            self.run(SKAction.sequence([wait4,reset]))
        }
    override func update(_ currentTime: TimeInterval) {
        if GameViewController.darkmode == true{
            modalitaDark = true
        }
        else{
            modalitaDark = false
        }
    }
    required init?(coder aDecoder: NSCoder) {
              fatalError("init(coder:) has not been implemented")
          }
    
}

