//
//  TravelModesTabCell.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

class TravelModesTabCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}
