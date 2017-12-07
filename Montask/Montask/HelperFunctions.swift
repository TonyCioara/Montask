//
//  HelperFunctions.swift
//  Montask
//
//  Created by Sunny Ouyang on 11/8/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import Foundation




extension Int {
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
