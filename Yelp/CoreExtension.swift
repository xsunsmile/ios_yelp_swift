//
//  CoreExtension.swift
//  Yelp
//
//  Created by Hao Sun on 2/14/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}