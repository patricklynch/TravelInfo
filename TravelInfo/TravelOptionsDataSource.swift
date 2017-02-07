//
//  TravelOptionsDataSource.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

class TravelOptionsDataSource: NSObject, UITableViewDataSource, SelfUpdatingDataSource {
    
    let travelMode: TravelMode
    
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
    
    func load(completion: (()->())?) {
        let operation = LoadTravelOptions(for: travelMode)
        operation.queue() {
            if let options = operation.results {
                self.items = NSOrderedSet(array: options)
                
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
}
