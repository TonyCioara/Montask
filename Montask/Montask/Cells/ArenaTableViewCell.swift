//
//  ArenaTableViewCell.swift
//  Montask
//
//  Created by Sunny Ouyang on 12/6/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
protocol ArenaCellDelegate {
    func sendIndex(index:IndexPath)
}
class ArenaTableViewCell: UITableViewCell {

   
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var monsterImage1: UIImageView!
    @IBOutlet weak var monsterImage2: UIImageView!
    @IBOutlet weak var monsterImage3: UIImageView!
    var indexPath: IndexPath?
    var delegate: ArenaCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func fightButtonTapped(_ sender: Any) {
        self.delegate?.sendIndex(index: self.indexPath!)
    }
    
}
