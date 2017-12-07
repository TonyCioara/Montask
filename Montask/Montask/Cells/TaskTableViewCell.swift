//
//  TaskTableViewCell.swift
//  Montask
//
//  Created by Sunny Ouyang on 10/31/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

protocol TaskDelegate {
    func completeTask(indexPath: IndexPath)
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var delegate: TaskDelegate!
    var indexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction func completedButtonTapped(_ sender: Any) {
        delegate.completeTask(indexPath: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
