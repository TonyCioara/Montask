//
//  FriendRequestTableViewCell.swift
//  Montask
//
//  Created by Sunny Ouyang on 12/3/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

protocol friendRequestCellDelegate {
    func acceptedRequest(index: IndexPath)
    func rejectedRequest(index: IndexPath)
}

class FriendRequestTableViewCell: UITableViewCell {
    var index: IndexPath!
    var delegate: friendRequestCellDelegate!
    @IBOutlet weak var friendRequestLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func acceptButtonTapped(_ sender: Any) {
        delegate.acceptedRequest(index: self.index)
    }
    @IBAction func denyButtonTapped(_ sender: Any) {
        delegate.rejectedRequest(index: self.index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
