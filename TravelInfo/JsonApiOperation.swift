//
//  JsonApiOperation.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/3/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TravelMode: String {
    case flight = "w60i"
    case train = "3zmcy"
    case bus = "37yzm"
    
    var localizedTitle: String {
        switch self {
        case .flight:   return NSLocalizedString("Flight", comment: "")
        case .bus:      return NSLocalizedString("Bus", comment: "")
        case .train:    return NSLocalizedString("Train", comment: "")
        }
    }
    
    static var all: [TravelMode] {
        return [train, bus, flight]
    }
}

/// Base class for all opertions that will execute a network request
/// against the main API
class LoadTravelOptions: AsyncOperation {
    
    let travelMode: TravelMode
    let baseUrl: URL = URL(string: "https://api.myjson.com")!
    let apiPath: String = "bins"
    
    private(set) var results: [TravelOption]?
    private(set) var error: Error?
    
    // Intentionally a non-optional var so that it can be mocked with
    // another object that conforms to `RequestExecutor`
    var requestExecutor: RequestExecutor = DefaultRequestEecutor()
    
    required init(travelMode: TravelMode) {
        self.travelMode = travelMode
    }
    
    var fullUrl: URL? {
        return baseUrl
            .appendingPathComponent(apiPath)
            .appendingPathComponent(travelMode.rawValue)
    }
    
    override func execute() {
        guard let url = fullUrl else {
            cancel()
            didFinish()
            return
        }
        requestExecutor.executeRequest(with: url) { data, response, error in
            if let data = data {
                let json = JSON(data: data)
                self.results = json.array?.flatMap({ TravelOption(json: $0) })
                
            } else if let error = error {
                self.error = error
            }
            self.didFinish()
        }
    }
}
