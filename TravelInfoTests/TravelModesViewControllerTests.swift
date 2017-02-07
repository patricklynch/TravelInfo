//
//  TravelModesViewControllerTests.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/7/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import XCTest
@testable import TravelInfo

class TravelModesViewControllerTests: XCTestCase {
    
    func testCache() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "TravelModesViewController") as? TravelModesViewController else {
            XCTFail("Failed to load view controller from bundle")
            return
        }
        print(viewController.view) //< Forces view to load
        
        XCTAssertNil(viewController.currentViewController)
        viewController.showViewController(for: TravelMode.bus)
        XCTAssertNotNil(viewController.currentViewController)
        let cachedViewController = viewController.cache.object(forKey: TravelMode.bus.cacheKey)
        XCTAssertNotNil(cachedViewController?.view.superview)
        XCTAssertEqual(viewController.currentViewController, cachedViewController, "View controller selected should be cached")
        
        viewController.showViewController(for: TravelMode.train)
        XCTAssertNotNil(viewController.currentViewController)
        let nextCachedViewController = viewController.cache.object(forKey: TravelMode.train.cacheKey)
        XCTAssertNil(cachedViewController?.view.superview)
        XCTAssertNotNil(nextCachedViewController?.view.superview)
        XCTAssertEqual(viewController.currentViewController, nextCachedViewController, "Next controller selected should be cached")
        
        let oldCachedViewController = viewController.cache.object(forKey: TravelMode.bus.cacheKey)
        XCTAssertNotNil(oldCachedViewController, "Old view controller should still be cached")
        viewController.showViewController(for: TravelMode.bus)
        XCTAssertEqual(viewController.currentViewController, oldCachedViewController, "Cached view controller should be used again as current view contorller")
    }
}
