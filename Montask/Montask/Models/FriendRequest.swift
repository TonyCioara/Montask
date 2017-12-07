//
//  FriendRequest.swift
//  Montask
//
//  Created by Sunny Ouyang on 12/3/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation
import UIKit


class Request: Codable {
    let sender: String
    let receiver: String
    
    init(sender: String, receiver: String) {
        self.sender = sender
        self.receiver = receiver
    }
    
}



