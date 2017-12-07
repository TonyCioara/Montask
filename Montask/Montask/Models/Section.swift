//
//  Section.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/27/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation


struct Section {
    let name: String
    let tasks: [Task]
    var expanded: Bool
    
    init(name: String, tasks: [Task], expanded: Bool) {
        self.name = name
        self.tasks = tasks
        self.expanded = expanded
    }
}
