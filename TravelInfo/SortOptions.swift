//
//  SortOptions.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

protocol Sortable {
    var sortOption: SortOptions? { set get }
}

enum SortOptions {
    case price, duration, departure
    
    var toolBarImage: UIImage {
        switch self {
        case .price:        return UIImage(named: "icon-price")!
        case .duration:     return UIImage(named: "icon-duration")!
        case .departure:    return UIImage(named: "icon-departure")!
        }
    }
    
    static var all: [SortOptions] {
        return [price, duration, departure]
    }
}
