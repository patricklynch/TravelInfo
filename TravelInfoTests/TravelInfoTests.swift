//
//  TravelInfoTests.swift
//  TravelInfoTests
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import XCTest
@testable import TravelInfo
import SwiftyJSON

class TravelInfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTravelOptionsParsing() {
        guard let json = jsonFromBundle(named:"travel-options.json"),
            let travelOptions = json.array?.flatMap({ TravelOption(json: $0) }) else {
                XCTFail("Failed to parse JSON models.")
                return
        }
        
        XCTAssertEqual(travelOptions.count, 3)
        guard let firstOption = travelOptions.first else {
            XCTFail("Failed get model for further tests.")
            return
        }
        
        XCTAssertEqual(firstOption.id, 1)
        let urlString = "http://cdn-goeuro.com/static_content/web/logos/{size}/postbus.png"
        XCTAssertEqual(firstOption.providerLogoUrlString, urlString)
        XCTAssertEqual(firstOption.priceInEuros, 5.48)
        XCTAssertEqual(firstOption.departureTime, "2:41")
        XCTAssertEqual(firstOption.arrivalTime, "16:56")
        XCTAssertEqual(firstOption.numberOfStops, 2)
        let url = URL(string: "http://cdn-goeuro.com/static_content/web/logos/99/postbus.png")
        XCTAssertEqual(firstOption.providerLogoUrl(at: 99), url)
    }
    
    func testTravelOptionsParsingWithErrors() {
        guard let json = jsonFromBundle(named: "travel-options-errors.json"),
            let travelOptions = json.array?.flatMap({ TravelOption(json: $0) }) else {
                XCTFail("Failed to parse JSON models.")
                return
        }
        
        XCTAssertEqual(travelOptions.count, 0, "Parsing of all models in the array should have failed.  Each one has a required property missing.")
    }
    
    private func jsonFromBundle(named filename: String) -> JSON? {
        guard let url = Bundle(for: type(of: self)).resourceURL?.appendingPathComponent(filename),
            let data = try? Data(contentsOf: url, options: []) else {
                return nil
        }
        return JSON(data: data)
    }
}
