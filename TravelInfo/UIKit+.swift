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

import SDWebImage

extension UIImageView {
    
    func fadeInImage(at imageUrl: URL, completion: (()->())? = nil) {
        sd_setImage(with: imageUrl) { image, error, cacheType, url in
            if cacheType == .none {
                self.image = image
                self.alpha = 0.0
                UIView.animate(withDuration: 0.35) {
                    self.alpha = 1.0
                }
            } else {
                self.alpha = 1.0
            }
            completion?()
        }
    }
}

extension UIView {
    
    /// Loads a nib named `nibNameOrNib`, iterates through each of the views within and returns
    /// the first one whose type matches generic type `T`.
    static func fromNib<T: UIView>(_ nibNameOrNil: String? = nil) -> T {
        let name = nibNameOrNil ?? string(fromClass:T.self)
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for view in nibViews ?? [] {
            if let typedView = view as? T {
                return typedView
            }
        }
        fatalError( "Could not load view from nib named: \(name)" )
    }
}

/// Returns the name of a class by itself (without any package name)
func string(fromClass aClass: AnyClass) -> String {
    var className = NSStringFromClass(aClass)
    let components = className.components(separatedBy: ".")
    if let last = components.last, last.characters.count > 0 {
        className = last
    }
    return className as String
}
