//
//  PersonalCollectionViewHeader.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/18/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

protocol HeaderviewDelegate {
    func sendMonster(monster: Monster)
}

class PersonalCollectionViewHeader: UICollectionReusableView {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topMonsterImage: UIImageView!
    @IBOutlet weak var secondMonsterImage: UIImageView!
    @IBOutlet weak var thirdMonsterImage: UIImageView!
    @IBOutlet weak var topUIView: UIView!
    @IBOutlet weak var thirdUIView: UIView!
    @IBOutlet weak var secondUIView: UIView!
    var topThreeMonsters: [Monster]!
    var delegate: HeaderviewDelegate?
    
    @IBAction func topMonsterTapped(_ sender: Any) {
        delegate?.sendMonster(monster: self.topThreeMonsters[2])
    }
    @IBAction func secondMonsterTapped(_ sender: Any) {
        delegate?.sendMonster(monster: self.topThreeMonsters[1])
    }
    
    @IBAction func thirdMonsterTapped(_ sender: Any) {
        delegate?.sendMonster(monster: self.topThreeMonsters[0])
    }
    
    
    
}
