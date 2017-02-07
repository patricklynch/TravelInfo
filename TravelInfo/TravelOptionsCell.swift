//
//  TravelOptionsCell.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit
import SDWebImage

class TravelOptionCell: UITableViewCell {
    
    private static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_DE")
        return formatter
    }()
    
    private static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [ .hour, .minute ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }()
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var imageWidth: NSLayoutConstraint!
    
    var travelOption: TravelOption? {
        didSet {
            guard let travelOption = travelOption else {
                return
            }
            
            let arrivalString = TravelOption.dateFormatter.string(from: travelOption.arrivalTime)
            let departureString = TravelOption.dateFormatter.string(from: travelOption.departureTime)
            timeLabel.text = "\(arrivalString) – \(departureString)"
            priceLabel.text = TravelOptionCell.currencyFormatter.string(from: NSNumber(value: travelOption.priceInEuros))
            durationLabel.text = TravelOptionCell.durationFormatter.string(from: travelOption.travelDuration)
            if let imageUrl = travelOption.providerLogoUrl() {
                logoImageView.fadeInImage(at: imageUrl) {
                    self.updateImageView()
                }
            } else {
                logoImageView.image = nil
            }
        }
    }
    
    private func updateImageView() {
        guard let image = logoImageView.image else {
            return
        }
        let aspect = image.size.width / image.size.height
        let targetWidth = logoImageView.bounds.height * aspect
        imageWidth.constant = targetWidth
        logoImageView.layoutIfNeeded()
    }
}
