//
//  MonsterDetailViewController.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/22/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
import Kingfisher

class MonsterDetailViewController: UIViewController {

    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterImage: UIImageView!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var specialPowerLabel: UILabel!
    
    
    var monster: Monster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

}

extension MonsterDetailViewController {
    func setUp () {
        guard let monster = self.monster else {return}
        monsterNameLabel.text = monster.name
//        monsterImage.kf.setImage(with: URL(string: monster.imageUrl))
        var monsterName = monster.imageUrl
        monsterImage.image = UIImage(named: monsterName)
        healthLabel.text = "Health: \(monster.health)"
        specialPowerLabel.text = "Special Power: \(monster.specialPower)"
        powerLabel.text = "Power: \(monster.power)"
    }
}
