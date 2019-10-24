import SpriteKit
class GameScene: SKScene {
    
    
    var gameSelectorLabel : SKLabelNode!
    var logo : SKSpriteNode!
    var select1, select2, select3, sfondo : SKSpriteNode!
    var emitter : SKEmitterNode!
    var transition : SKTransition!
    var font = "Noteworthy"
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
    static var flag = 0

    static var music = ["m1.mp3","m2.mp3","m3.mp3","m4.mp3","m5.mp3"]
    
    static func giveRandom () -> Int{
        return Int.random(in: 0..<5)
    }
    override func didMove(to view: SKView) {
        if GameScene.flag == 0{
            self.run(SKAction.repeatForever(SKAction.playSoundFileNamed(GameScene.music[Int.random(in: 0..<5)], waitForCompletion: true)))
            GameScene.flag = 1

        }
        
        backgroundColor = .white
        
        transition = SKTransition.doorway(withDuration: 0.8)
        
        logo = SKSpriteNode()
        logo.texture = SKTexture(image: #imageLiteral(resourceName: "LOGO_APP-1"))
        logo.size = CGSize(width: 400, height: 400)
        logo.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 370)
        logo.zPosition = 14
        
        addChild(logo)
        
        sfondo = SKSpriteNode()
        sfondo.texture = SKTexture(image: #imageLiteral(resourceName: "Home"))
        sfondo.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        sfondo.zPosition = 2
        sfondo.size = self.size
        
        gameSelectorLabel = SKLabelNode(text: "WasteAwaY")
        gameSelectorLabel.fontName = font
        gameSelectorLabel.fontSize = 90
        gameSelectorLabel.fontColor = UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1)
        gameSelectorLabel.position = CGPoint(x: frame.size.width/2, y: 3*frame.size.height/4 + 150)
        gameSelectorLabel.zPosition = sfondo.zPosition+1

        select1 = SKSpriteNode()
        select1.texture = SKTexture(image: #imageLiteral(resourceName: "Flower-3"))
        select1.size = CGSize(width: 120, height: 120)
        select1.position = CGPoint(x: 189, y: 510)
        select1.zPosition = sfondo.zPosition+1
        
        select2 = SKSpriteNode()
        select2.texture = SKTexture(image: #imageLiteral(resourceName: "image 17"))
        select2.size = CGSize(width: 120, height: 120)
        select2.position = CGPoint(x: 414, y: 510)
        select2.zPosition = sfondo.zPosition+1
                
        select3 = SKSpriteNode()
        select3.texture = SKTexture(image: #imageLiteral(resourceName: "casafoglia"))
        select3.size = CGSize(width: 150, height: 150)
        select3.position = CGPoint(x: 640, y: 510)
        select3.zPosition = sfondo.zPosition+1

        emitter = SKEmitterNode(fileNamed: "Magic")
        emitter.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        emitter.zPosition = sfondo.zPosition-1
        
        addChild(emitter)
        addChild(sfondo)
        addChild(gameSelectorLabel)
        addChild(select1)
        addChild(select2)
        addChild(select3)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches{
            let location = t.location(in: self)
            if select1.contains(location){
                self.removeAction(forKey: "stop")
                run(SKAction.run {
                    (self.view?.presentScene(Game1(size: self.size), transition: SKTransition.fade(withDuration: 0.8)))!
                })
                
            }
            if select2.contains(location){
                self.removeAction(forKey: "stop")
                run(SKAction.run {
                    (self.view?.presentScene(Game2(size: self.size), transition: SKTransition.fade(withDuration: 0.8)))!
                    
                })
            }
            if select3.contains(location){
                self.removeAction(forKey: "stop")
                run(SKAction.run {
                    (self.view?.presentScene(Game3(size: self.size), transition: SKTransition.fade(withDuration: 0.8)))!
                    
                })
            }
        }
    }
    
   
    override func update(_ currentTime: TimeInterval) {
        if GameViewController.darkmode == true{
            modalitaDark = true
            print("dark on")
        }
        else{
            modalitaDark = false
        }
    }
    
}
