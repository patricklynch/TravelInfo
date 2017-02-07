//
//  RequestExecutor.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation

protocol RequestExecutor {
    func executeRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
}

struct DefaultRequestEecutor: RequestExecutor {
    func executeRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}
