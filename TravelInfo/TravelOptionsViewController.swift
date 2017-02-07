//
//  TravelOptionsViewController.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

enum AnimationDirection: CGFloat {
    case left = -1.0, right = 1.0, none = 0.0
}

class TravelOptionsViewController: UIViewController, UITableViewDelegate, Sortable {
    
    private var dataSource: TravelOptionsDataSource!
    
    var direction: AnimationDirection = .none
    
    static func create(with travelMode: TravelMode) -> TravelOptionsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TravelOptionsViewController") as! TravelOptionsViewController
        viewController.dataSource = TravelOptionsDataSource(travelMode: travelMode)
        return viewController
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = tableView
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.alpha = 0.0
        dataSource.load() { [weak self] in
            self?.animateAppearance()
        }
    }
    
    private func animateAppearance() {
        view.alpha = 0.0
        UIView.animate(withDuration: 0.35) {
            self.view.alpha = 1.0
        }
        
        guard direction != .none else {
            return
        }
        
        view.transform = CGAffineTransform(translationX: direction.rawValue * 100.0, y: 0.0)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.view.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Sortable
    
    var sortOption: SortOptions? {
        didSet {
            dataSource.sortOption = sortOption
        }
    }
}
