//
//  Models.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TravelOption {
    static let sizeMacro = "{size}"
    
    let id: Int
    let providerLogoUrlString: String
    let priceInEuros: Float
    let departureTime: String
    let arrivalTime: String
    let numberOfStops: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let providerLogoUrlString = json["provider_logo"].string,
            let priceInEuros = json["price_in_euros"].float,
            let departureTime = json["departure_time"].string,
            let arrivalTime = json["arrival_time"].string,
            let numberOfStops = json["number_of_stops"].int else {
                return nil
        }
        self.id = id
        self.providerLogoUrlString = providerLogoUrlString
        self.priceInEuros = priceInEuros
        self.departureTime  = departureTime
        self.arrivalTime  = arrivalTime
        self.numberOfStops  = numberOfStops
    }
    
    func providerLogoUrl(at size: Int = 63) -> URL? {
        let replacedString = providerLogoUrlString
            .replacingOccurrences(of: TravelOption.sizeMacro, with: "\(size)")
        
        return URL(string: replacedString)
    }
}
