//
//  Muica.swift
//  Prj
//
//  Created by Aldo D'Orso on 22/10/2019.
//  Copyright © 2019 Aldo D'Orso. All rights reserved.
//

import Foundation
import UIKit

class Musica: UITraitCollection {
    var d = UITraitCollection()
    static var dark : Bool!
    var music = ["m1.mp3","m2.mp3","m3.mp3","m4.mp3","m5.mp3"]
    override init() {
        super.init()
        if d.userInterfaceStyle == UIUserInterfaceStyle.light{
            Musica.dark = false
        }
        else {
            dark = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
