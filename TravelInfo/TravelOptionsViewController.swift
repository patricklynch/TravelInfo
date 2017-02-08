//
//  TravelOptionsViewController.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

class TravelOptionsViewController: UIViewController, UITableViewDelegate, Sortable, AnimatableViewController {
    
    private var dataSource: TravelOptionsDataSource!
    
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
        
        guard let direction = direction else {
            return
        }
        
        let transform: CGAffineTransform
        switch direction {
        case .up:
            transform = CGAffineTransform(translationX: 0.0, y: 100.0)
        case .left:
            transform = CGAffineTransform(translationX: 100.0, y: 0.0)
        case .right:
            transform = CGAffineTransform(translationX: -100.0, y: 0.0)
        }
        
        view.transform = transform
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
    
    // MARK: - AnimatableViewController
    
    var direction: AnimationDirection?
    
    // MARK: - Sortable
    
    var sortOption: SortOptions? {
        didSet {
            dataSource.sortOption = sortOption
        }
    }
}
