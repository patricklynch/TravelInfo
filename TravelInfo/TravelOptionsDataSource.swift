//
//  TravelOptionsDataSource.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

class TravelOptionsDataSource: NSObject, UITableViewDataSource, SelfUpdatingDataSource, Sortable {
    
    let travelMode: TravelMode
    
    /// To prevent locking the main thread while sorting large data sets:
    private let sortQueue = DispatchQueue(label: "com.lynchdev.BusInfo.sortQueue")
    
    init(travelMode: TravelMode) {
        self.travelMode = travelMode
    }
    
    private(set) var items = NSOrderedSet(){
        didSet {
            if items.count != oldValue.count {
                delegate?.dataSource(self, didUpdateItemsFromOldValue: oldValue, toNewValue: items, section: 0)
            } else {
                delegate?.dataSource(self, redecorateItemsIn: 0)
            }
        }
    }
    
    private(set) var unsortedItems = NSOrderedSet() {
        didSet {
            updateSortedItems()
        }
    }
    
    private func updateSortedItems() {
        guard let sortOption = sortOption else {
            items = unsortedItems
            return
        }
        
        let options = unsortedItems.flatMap { $0 as? TravelOption }
        sortQueue.async {
            let results = options.sorted {
                switch sortOption {
                case .price:
                    return $0.priceInEuros < $1.priceInEuros
                case .duration:
                    return $0.travelDuration < $1.travelDuration
                case .departure:
                    return $0.departureTime.timeIntervalSinceNow < $1.departureTime.timeIntervalSinceNow
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.items = NSOrderedSet(array: results)
            }
        }
    }
    
    func load(completion: (()->())?) {
        let operation = LoadTravelOptions(for: travelMode)
        operation.queue() {
            if let options = operation.results {
                self.unsortedItems = NSOrderedSet(array: options)
                
            } else if let error = operation.error {
                print(error)
            }
            completion?()
        }
    }
    
    // MARK: - SelfUpdatingDataSource
    
    var delegate: SelfUpdatingDataSourceDelegate?
    
    func decorate(cell: UIView, at indexPath: IndexPath) {
        let cell = cell as! TravelOptionCell
        let travelOption = items[indexPath.row] as! TravelOption
        cell.travelOption = travelOption
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TravelOptionCell.defaultReuseIdentifier)!
        decorate(cell: cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // MARK: - Sortable
    
    var sortOption: SortOptions? = .departure {
        didSet {
            items = NSOrderedSet(array: [])
            
            DispatchQueue.main.asyncAfter(delay: 0.25) {
                self.updateSortedItems()
            }
        }
    }
}
