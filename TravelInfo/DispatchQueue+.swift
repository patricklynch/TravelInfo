//
//  DispatchQueue+.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func asyncAfter(delay: TimeInterval, closure: @escaping ()->()) {
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        asyncAfter(deadline: dispatchTime) {
            closure()
        }
    }
}
