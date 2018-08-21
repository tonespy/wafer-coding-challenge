//
//  CountryManagerTests.swift
//  wafer-coding-challengeTests
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import XCTest
@testable import wafer_coding_challenge

class CountryManagerTests: XCTestCase {
    
    var countryData: Data?
    var countryManager: CountryManagerProtocol?
    
    override func setUp() {
        super.setUp()
        countryData = loadStubFromBundle(withName: "all-countries", extension: "json")
    }
    
    override func tearDown() {
        super.tearDown()
        countryData = nil
        countryManager = nil
    }
    
    func testcountry_SuccessfulRequest() {
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: countryData)
        XCTAssertNotNil(countryManager)
        
        // When fetch country
        let expect = XCTestExpectation(description: "country_successful_fetch_callback")
        
        countryManager!.fetchCountries { (countries, error) in
            expect.fulfill()
            XCTAssertNil(error)
            XCTAssertNotNil(countries)
            XCTAssert(countries!.count > 0)
        }
        
        wait(for: [expect], timeout: 4)
    }
    
    func testCountry_SuccessfulBadData() {
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: nil)
        XCTAssertNotNil(countryManager)
        
        // When fetch country with bad data
        let expect = XCTestExpectation(description: "country_failed_fetch_callback")
        
        countryManager!.fetchCountries { (countries, error) in
            expect.fulfill()
            XCTAssertNil(countries)
            XCTAssertNotNil(error)
            XCTAssertEqual(CountryError.invalidResponse, error!)
        }
        
        wait(for: [expect], timeout: 4)
    }
}
