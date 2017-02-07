//
//  ViewController.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

extension TravelMode {
    var cacheKey: NSString {
        return rawValue as NSString
    }
}

class TravelModesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak private(set) var tabBarCollectionView: UICollectionView!
    @IBOutlet private weak var pageContainerView: UIView!
    
    let cache = NSCache<NSString, TravelOptionsViewController>()
    
    weak private(set) var currentViewController: UIViewController?
    private(set) var currentIndexPath: IndexPath?
    
    private let dataSource = TravelModesDataSource()
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleViewModel =  TitleView.ViewModel(
            origin: "Berlin",
            destination: "Munich",
            date: Date()
        )
        navigationItem.titleView = TitleView.create(viewModel:titleViewModel)
        
        tabBarCollectionView.dataSource = dataSource
        tabBarCollectionView.delegate = self
        
        DispatchQueue.main.asyncAfter(delay: 0.0) {
            self.setDefaultSelection()
        }
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.toolbar.barTintColor = Color.blue
        tabBarCollectionView.backgroundColor = Color.blue
    }
    
    func setDefaultSelection() {
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        tabBarCollectionView.selectItem(at: defaultIndexPath, animated: true, scrollPosition: .left)
        onIndexPathSelected(defaultIndexPath)
    }
    
    func onIndexPathSelected(_ indexPath: IndexPath) {
        let travelMode = dataSource.travelModes[indexPath.item]
        let direction: AnimationDirection
        if let currentIndexPath = currentIndexPath {
            if indexPath.item < currentIndexPath.item {
                direction = .right
            } else if indexPath.item > currentIndexPath.item {
                direction = .left
            } else {
                direction = .none
            }
        } else {
            direction = .none
        }
        
        let viewController: TravelOptionsViewController
        if let cachedViewController = cache.object(forKey: travelMode.cacheKey) {
            viewController = cachedViewController
        } else {
            let newViewController = TravelOptionsViewController.create(with: travelMode)
            viewController = newViewController
            cache.setObject(newViewController, forKey: travelMode.cacheKey)
        }
        
        if let currentViewController = currentViewController {
            currentViewController.willMove(toParentViewController: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.didMove(toParentViewController: nil)
        }
        currentViewController = viewController
        
        viewController.direction = direction
        viewController.willMove(toParentViewController: self)
        pageContainerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: UIView] = [ "view" : viewController.view ]
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views)
        pageContainerView.addConstraints(constraintsV + constraintsH)
        viewController.didMove(toParentViewController: self)
        currentIndexPath = indexPath
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentIndexPath != indexPath else {
            return
        }
        onIndexPathSelected(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(dataSource.travelModes.count)
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
