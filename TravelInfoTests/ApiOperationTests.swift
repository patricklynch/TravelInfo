//
//  ApiOperationTests.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import XCTest
@testable import TravelInfo
import SwiftyJSON

class LoadTravelOptionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFlightUrl() {
        let flightOperation = LoadTravelOptions(for: .flight)
        let expectedUrl = "https://api.myjson.com/bins/w60i"
        XCTAssertEqual(flightOperation.fullUrl?.absoluteString, expectedUrl)
    }
    
    func testTrainUrl() {
        let flightOperation = LoadTravelOptions(for: .train)
        let expectedUrl = "https://api.myjson.com/bins/3zmcy"
        XCTAssertEqual(flightOperation.fullUrl?.absoluteString, expectedUrl)
    }
    
    func testBusUrl() {
        let flightOperation = LoadTravelOptions(for: .bus)
        let expectedUrl = "https://api.myjson.com/bins/37yzm"
        XCTAssertEqual(flightOperation.fullUrl?.absoluteString, expectedUrl)
    }
    
    func testLoadTravelOptions() {
        let mockRequestExecutor = MockExecutor(filename: "travel-options.json", forceError: false)
        let operation = LoadTravelOptions(for: .flight)
        operation.requestExecutor = mockRequestExecutor
        operation.main()
        
        XCTAssertNil(operation.error)
        XCTAssertNotNil(operation.results)
        XCTAssertEqual(operation.results?.count, 3)
    }
    
    func testLoadTravelOptionsError() {
        let mockRequestExecutor = MockExecutor(filename: "travel-options.json", forceError: true)
        let operation = LoadTravelOptions(for: .flight)
        operation.requestExecutor = mockRequestExecutor
        operation.main()
        
        XCTAssertNotNil(operation.error)
        XCTAssertNil(operation.results)
    }
}

// MARK: - Mocks

class MockExecutor: RequestExecutor {
    
    let forceError: Bool
    let filename: String
    
    init(filename: String, forceError: Bool = false) {
        self.forceError = forceError
        self.filename = filename
    }
    
    private func dataFrom(named filename: String) -> Data? {
        guard let url = Bundle(for: type(of: self)).resourceURL?.appendingPathComponent(filename),
            let data = try? Data(contentsOf: url, options: []) else {
                return nil
        }
        return data
    }
    
    // MARK: - RequestExecutor
    
    func executeRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let data = dataFrom(named: filename)
        if forceError {
            completionHandler(nil, nil, NSError(domain: "unit.test.intentional.error", code: 99, userInfo: [:]))
        } else {
            completionHandler(data, nil, nil)
        }
    }
}
