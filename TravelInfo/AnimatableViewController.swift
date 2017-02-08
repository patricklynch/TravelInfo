//
//  AnimatableViewController.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/8/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

enum AnimationDirection: CGFloat {
    case left, right, up
}

protocol AnimatableViewController {
    var direction: AnimationDirection? { get set }
}
