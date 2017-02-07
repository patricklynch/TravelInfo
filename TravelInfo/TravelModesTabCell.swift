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
    
    private var selectedHeightValue: CGFloat = 0.0
    @IBOutlet private weak var selectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var selectionView: UIView! {
        didSet {
            selectedHeightValue = selectionView.bounds.height
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateSelectedState()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateSelectedState()
    }
    
    override var isSelected: Bool {
        didSet {
            guard oldValue != isSelected else {
                return
            }
            updateSelectedState()
        }
    }
    
    private func updateSelectedState() {
        let targetHeight: CGFloat
        if isSelected {
            targetHeight = selectedHeightValue
        } else {
            targetHeight = 0.0
        }
        
        selectionViewHeight.constant = targetHeight
        selectionView.layoutIfNeeded()
    }
}
