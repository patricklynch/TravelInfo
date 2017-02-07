//
//  ViewController.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let operation = LoadTravelOptions(travelMode: .flight)
        operation.queue() {
            if let options = operation.results {
                print(options)
            } else if let error = operation.error {
                print(error)
            }
        }
    }
}
