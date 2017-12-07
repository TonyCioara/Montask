//
//  FriendsTableViewCell.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/11/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit
protocol friendCellDelegate {
    func sendIndex(index:IndexPath)
}
class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var monster1Image: UIImageView!
    @IBOutlet weak var monster2Image: UIImageView!
    @IBOutlet weak var monster3Image: UIImageView!
    var delegate: friendCellDelegate?
    var index: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func battleButtonTapped(_ sender: Any) {
        self.delegate?.sendIndex(index: self.index!)
    }
    
    

}
