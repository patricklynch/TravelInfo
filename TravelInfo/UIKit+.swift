//
//  UIKit+.swift
//  CarBrowser
//
//  Created by Patrick Lynch on 1/31/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
