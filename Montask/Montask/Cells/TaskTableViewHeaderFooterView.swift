//
//  TaskTableViewHeaderFooterView.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/27/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: TaskTableViewHeaderFooterView, section: Int)
}

class TaskTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction(gestureRecognizer:))))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Normally we would set our cells like cell.textlabel, or w/e, but here, we have a custom function that sets up the whole expandable headerView for us.
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    //This function will activate whenever we tap the headerView, and we will send that tap action to our receiver, which will toggle the selected section of our tableview
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! TaskTableViewHeaderFooterView
        delegate?.toggleSection(header: self, section: cell.section)
    }

}
