//
//  TravelOption.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TravelOption: CustomDebugStringConvertible, Equatable, Hashable {
    static let sizeMacro = "{size}"
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let id: Int
    let providerLogoUrlString: String
    let priceInEuros: Float
    let departureTime: Date
    let arrivalTime: Date
    let numberOfStops: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let providerLogoUrlString = json["provider_logo"].string,
            let priceInEuros = json["price_in_euros"].floatFromFloatOrString,
            let departureTime = json["departure_time"].dateFromString,
            let arrivalTime = json["arrival_time"].dateFromString,
            let numberOfStops = json["number_of_stops"].int else {
                return nil
        }
        self.id = id
        self.providerLogoUrlString = providerLogoUrlString
        self.priceInEuros = priceInEuros
        self.numberOfStops = numberOfStops
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
    }
    
    func providerLogoUrl(at size: Int = 63) -> URL? {
        let replacedString = providerLogoUrlString
            .replacingOccurrences(of: TravelOption.sizeMacro, with: "\(size)")
        
        return URL(string: replacedString)
    }
    
    var travelDuration: TimeInterval {
        return arrivalTime.timeIntervalSince(departureTime)
    }
    
    // MARK: - CustomDebugStringConvertible
    
    var debugDescription: String {
        return "<TravelOption>\n"
            + "id = \(id)\n"
            + "\tproviderLogoUrlString = \(providerLogoUrlString)\n"
            + "\tpriceInEuros = \(priceInEuros)\n"
            + "\tdepartureTime  = \(departureTime)\n"
            + "\tarrivalTime  = \(arrivalTime)\n"
            + "\tnumberOfStops  = \(numberOfStops)\n"
    }
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return departureTime.hashValue + arrivalTime.hashValue + priceInEuros.hashValue
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: TravelOption, rhs: TravelOption) -> Bool {
        return lhs.departureTime == rhs.departureTime && lhs.arrivalTime == rhs.arrivalTime && lhs.priceInEuros == rhs.priceInEuros
    }
}

fileprivate extension JSON {
    
    var floatFromFloatOrString: Float? {
        if let string = string, let floatFromString = Float(string) {
            return floatFromString
        } else {
            return float
        }
    }
    
    var dateFromString: Date? {
        guard let string = string else {
            return nil
        }
        return TravelOption.dateFormatter.date(from: string)
    }
}
