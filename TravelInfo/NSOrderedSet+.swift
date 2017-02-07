//
//  NSOrderedSet+.swift
//  CarBrowser
//
//  Created by Patrick Lynch on 1/31/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation

extension NSOrderedSet {
    
    func orderedSet(appending objects: [Any]) -> NSOrderedSet {
        let set = NSMutableOrderedSet(orderedSet: self)
        let total = set.count + objects.count
        set.insert(objects, at: IndexSet(integersIn: set.count..<total))
        return NSOrderedSet(orderedSet: set)
    }
}

