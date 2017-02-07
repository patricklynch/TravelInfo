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
    
    @IBOutlet private weak var tabBarCollectionView: UICollectionView!
    @IBOutlet private weak var pageContainerView: UIView!
    
    let cache = NSCache<NSString, UIViewController>()
    
    weak private(set) var currentViewController: UIViewController?
    
    private let dataSource = TravelModesDataSource()
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarCollectionView.dataSource = dataSource
        tabBarCollectionView.delegate = self
        
        let operation = LoadTravelOptions(travelMode: .flight)
        operation.queue() {
            if let options = operation.results {
                print(options)
            } else if let error = operation.error {
                print(error)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showViewController(for travelMode: TravelMode) {
        let viewController: UIViewController
        if let cachedViewController = cache.object(forKey: travelMode.cacheKey) {
            viewController = cachedViewController
        } else {
            let demoColors = [UIColor.red, UIColor.blue, UIColor.green]
            let newViewController = UIViewController()
            newViewController.view.backgroundColor = demoColors[Int(TravelMode.all.index(of: travelMode)!)]
            viewController = newViewController
            cache.setObject(newViewController, forKey: travelMode.cacheKey)
        }
        
        if let currentViewController = currentViewController {
            currentViewController.willMove(toParentViewController: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.didMove(toParentViewController: nil)
        }
        currentViewController = viewController
        
        viewController.willMove(toParentViewController: self)
        pageContainerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: UIView] = [ "view" : viewController.view ]
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views)
        pageContainerView.addConstraints(constraintsV + constraintsH)
        viewController.didMove(toParentViewController: self)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let travelMode = dataSource.travelModes[indexPath.item]
        showViewController(for: travelMode)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(dataSource.travelModes.count)
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
