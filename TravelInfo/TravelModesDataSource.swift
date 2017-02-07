//
//  TravelModesDataSource.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit


class TravelModesDataSource: NSObject, UICollectionViewDataSource {
    
    let travelModes = TravelMode.all
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = TravelModesTabCell.defaultReuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TravelModesTabCell
        let travelMode = travelModes[indexPath.item]
        cell.title = travelMode.localizedTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelModes.count
    }
}
