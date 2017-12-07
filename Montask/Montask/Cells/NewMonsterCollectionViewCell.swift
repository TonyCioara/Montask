//
//  NewMonsterCollectionViewCell.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/22/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

protocol newMonsterDelegate {
    func sendIndexPath(indexPath: IndexPath)
}

class NewMonsterCollectionViewCell: UICollectionViewCell {
    
    var delegate: newMonsterDelegate?
    var indexPath: IndexPath?
    var points: Int?
    
    @IBOutlet weak var hatchButton: UIButton!
    @IBOutlet weak var monsterTierLabel: UILabel!
    @IBOutlet weak var monsterEggImage: UIImageView!
    @IBOutlet weak var eggPriceLabel: UILabel!
    @IBAction func hatchEggTapped(_ sender: Any) {
        self.hatchButton.isUserInteractionEnabled = false
        delegate?.sendIndexPath(indexPath: indexPath!)
    }
}
