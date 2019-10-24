

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class Game1: SKScene ,SKPhysicsContactDelegate{
    
    var label, puntiLabel  : SKLabelNode!
    var btnBack, fiore, imm, albero, cestino, floor, nuvola, pause : SKSpriteNode!
    var timerNemici , timerNuvole: Timer!
    var state = 1
    var defaultSizeAbero = CGSize(width: 100, height: 200)
    var defaltPositionAlbero = CGPoint(x: 50, y: 370)
    
    var immCategoryMask : UInt32 =  0x1 << 0
    var nuvoleCategoryMask : UInt32 = 0x1 << 1
    var cestinoCategoryMask : UInt32 = 0x1 << 2
    
    var modalitaDark : Bool = false{
        didSet {
            if oldValue == false && modalitaDark == true {
                let darkMode = SKSpriteNode()
                darkMode.name = "DarkON"
                darkMode.color = .black
                darkMode.alpha = 0.4
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
    var font = "Noteworthy"
    var stagione = 0, i = 0
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
    
    var punteggio = 0{
        didSet{
            i += 1
            puntiLabel.text = "Score: \(punteggio)"
            albero.size = CGSize(width: albero.size.width+2, height: albero.size.height+4)
            albero.position = CGPoint(x: albero.position.x, y: albero.position.y+2)
            if punteggio % 100 == 0  {
                i=0
                cambiStagione(i: stagione)
                stagione += 1
                stagione %= 3
                albero.size = defaultSizeAbero
                albero.position = defaltPositionAlbero
            }
            if punteggio % 10 == 0{
                let arrayDiFiori : [UIImage] = [#imageLiteral(resourceName: "Flower-1"),#imageLiteral(resourceName: "Flower-2"),#imageLiteral(resourceName: "Flower-3"),#imageLiteral(resourceName: "Asset 14"),#imageLiteral(resourceName: "Asset 7")]
                let randomX = GKRandomDistribution(lowestValue: 0, highestValue: 828)
                let randomY = GKRandomDistribution(lowestValue: 230, highestValue: 300)
                fiore = SKSpriteNode()
                fiore.texture = SKTexture(image: arrayDiFiori[Int.random(in: 0..<arrayDiFiori.count)])
                fiore.size = CGSize(width: 50, height: 50)
                fiore.position = CGPoint(x: randomX.nextInt(), y: randomY.nextInt())
                fiore.zPosition = floor.zPosition + 1
                addChild(fiore)
            }
        }
    }
    
    func cambiStagione(i : Int){
        switch i {
        case 0:
            floor.texture = SKTexture(image: #imageLiteral(resourceName: "GrassJoinHillLeft"))
            albero.texture = SKTexture(image: #imageLiteral(resourceName: "Autumn Tree"))
            //Inverno
            
        case 1:
           floor.texture = SKTexture(image: #imageLiteral(resourceName: "GrassJoinHillLeft2 WithDropShadow-1"))
           albero.texture = SKTexture(image: #imageLiteral(resourceName: "Winter Tree"))
            // Autunno
            
        case 2:
            // primavera estate
            floor.texture = SKTexture(image: #imageLiteral(resourceName: "GrassCliffMid"))
            albero.texture = SKTexture(image: #imageLiteral(resourceName: "Tree"))
            
            
        default:
            break
        }
    }

    
    override init(size: CGSize) {
        super.init(size: size)

    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        backgroundColor = .cyan
    
        
        label = SKLabelNode(text: "Pause")
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2+300)
        label.fontColor = UIColor.blue
        label.fontSize = 100
        label.fontName = font
        label.isHidden = true
        
        floor = SKSpriteNode()
        floor.texture = SKTexture(image: #imageLiteral(resourceName: "GrassCliffMid"))
        floor.position = CGPoint(x: 414, y: 110)
        floor.size = CGSize(width: 828, height: 418)
        floor.zPosition = 1
        
        
        puntiLabel = SKLabelNode()
        puntiLabel.text = "Score: "
        puntiLabel.fontName = font
        puntiLabel.position = CGPoint(x: 150, y: 100)
        puntiLabel.fontSize = 40
        puntiLabel.zPosition = 11
        puntiLabel.fontColor = UIColor.black
        puntiLabel.zPosition = floor.zPosition+10
        
        btnBack = SKSpriteNode()
        btnBack.texture = SKTexture(image: #imageLiteral(resourceName: "backblue"))
        btnBack.position = CGPoint(x: 78, y: 1707)
        btnBack.size = CGSize(width: 38, height: 72)
        btnBack.zPosition = 11
        
        pause = SKSpriteNode()
        pause.texture = SKTexture(image: #imageLiteral(resourceName: "pauseBlue"))
        pause.position = CGPoint(x: 778, y: 1707)
        pause.size = CGSize (width: 38, height: 62)
        pause.zPosition = 11
        
        albero = SKSpriteNode()
        albero.name = "albero"
        albero.texture = SKTexture(image: #imageLiteral(resourceName: "Tree"))
        albero.position = CGPoint(x: 50, y: 370)
        albero.size = CGSize(width: 100, height: 200)
        albero.zPosition = 2
        
        
        cestino = SKSpriteNode()
        cestino.name = "cestino"
        cestino.texture = SKTexture(image: #imageLiteral(resourceName: "monnezza 2"))
        cestino.position = CGPoint(x: 414, y: 364)
        cestino.size = CGSize(width: 148, height: 221)
        cestino.zPosition = 3
            cestino.physicsBody = SKPhysicsBody(rectangleOf: cestino.size)
            cestino.physicsBody?.affectedByGravity = false
            cestino.physicsBody?.isDynamic = false
            cestino.physicsBody?.categoryBitMask = cestinoCategoryMask
            cestino.physicsBody?.contactTestBitMask = immCategoryMask


        addChild(label)
        addChild(pause)
        addChild(albero)
        addChild(cestino)
        addChild(floor)
        addChild(btnBack)
        addChild(puntiLabel)
        
        timerNemici = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(creaImmondizia), userInfo: nil, repeats: true)
        
        timerNuvole = Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(creaNuvole), userInfo: nil, repeats: true)
        
        mostraVite(lives: vite)

    }
    

    @objc func creaNuvole(){
        let randomX = GKRandomDistribution(lowestValue: -19, highestValue: 30)
        let randomY = GKRandomDistribution(lowestValue: 1050, highestValue: 1750)
        let arrDiNuvole : [UIImage] = [#imageLiteral(resourceName: "Cloud_1"),#imageLiteral(resourceName: "Cloud_2")]
        
        nuvola = SKSpriteNode()
        nuvola.texture = SKTexture(image: arrDiNuvole[Int.random(in: 0..<arrDiNuvole.count)])
        nuvola.size = CGSize (width: CGFloat.random(in: 100...200), height: CGFloat.random(in: 100...200))
        nuvola.position = CGPoint(x: randomX.nextInt(), y: randomY.nextInt())
            nuvola.physicsBody = SKPhysicsBody(circleOfRadius: 100)
            nuvola.physicsBody?.categoryBitMask = nuvoleCategoryMask
            nuvola.physicsBody?.collisionBitMask = 0
            nuvola.physicsBody?.affectedByGravity = false
        
        addChild(nuvola)
        nuvola.physicsBody?.applyImpulse(CGVector(dx: 299, dy: 10))
    }
    @objc func creaImmondizia (){
        let randomX = GKRandomDistribution(lowestValue: 0, highestValue: 800)
        let randomY = GKRandomDistribution(lowestValue: 1840, highestValue: 1900)

        
        imm = SKSpriteNode()
        imm.name = "imm"
        imm.texture = SKTexture(image: #imageLiteral(resourceName: "paperBallImage"))
        imm.size = CGSize(width: 100, height: 100)
        imm.position = CGPoint(x: randomX.nextInt(), y: randomY.nextInt())
        imm.zPosition = cestino.zPosition-1
        
        imm.physicsBody = SKPhysicsBody(circleOfRadius: imm.size.width/2)
        imm.physicsBody?.collisionBitMask = 0
        imm.physicsBody?.categoryBitMask = immCategoryMask
        
        addChild(imm)
        


        
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                
                if state == 1 {
                    for n in children{
                        if n.name == "imm"{ n.removeFromParent() }
                    }
                    timerNemici.invalidate()
                    label.isHidden = false
                    state = 0
//                    self.view?.isPaused = true
                }
                else{
                    timerNemici = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(creaImmondizia), userInfo: nil, repeats: true)
//                    self.view?.isPaused = false
                    
                    state = 1
                    label.isHidden = true
                }
            }
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        cestino.position.x = location.x
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let collisione = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        contact.bodyB.node?.removeFromParent()
        if collisione == cestinoCategoryMask | immCategoryMask{
            punteggio += 1

        }
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
    override func update(_ currentTime: TimeInterval) {
        
        for n in children{
            if n.position.y < -2 {
                vite -= 1
            }
            if (n.position.x < -30 || n.position.x > 900) || n.position.y < -3 {
                n.removeFromParent()
            }
            
        }
        if GameViewController.darkmode == true{
            modalitaDark = true
        }
        else{
            modalitaDark = false
        }
    }
    
}

