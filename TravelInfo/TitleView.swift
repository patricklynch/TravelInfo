//
//  TitleView.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        formatter.locale = Locale(identifier: "en_DE")
        return formatter
    }()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleView: UILabel!
    
    struct ViewModel {
        let origin: String
        let destination: String
        let date: Date
    }
    
    static func create(viewModel: ViewModel) -> TitleView {
        let view: TitleView = UIView.fromNib()
        view.viewModel = viewModel
        return view
    }
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            titleLabel.text = "\(viewModel.origin) – \(viewModel.destination)"
            subtitleView.text = TitleView.dateFormatter.string(from: viewModel.date)
        }
    }
}
