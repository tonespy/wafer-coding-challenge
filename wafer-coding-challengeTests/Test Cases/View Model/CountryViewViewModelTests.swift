//
//  CountryViewViewModelTests.swift
//  wafer-coding-challengeTests
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import XCTest
@testable import wafer_coding_challenge

class CountryViewViewModelTests: XCTestCase {
    
    var countryData: Data?
    var countryManager: CountryManagerProtocol?
    var viewModel: CountryViewViewModel?
    
    override func setUp() {
        super.setUp()
        countryData = loadStubFromBundle(withName: "all-countries", extension: "json")
    }
    
    override func tearDown() {
        countryData = nil
        countryManager = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testCountry_withSuccessfulData() {
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        XCTAssertNil(viewModel)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: countryData)
        XCTAssertNotNil(countryManager)
        
        viewModel = CountryViewViewModel(service: countryManager!)
        XCTAssertNotNil(viewModel)
    }
    
    func testCountryViewModel_forTopLoading() {
        
        // Given
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        XCTAssertNil(viewModel)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: countryData)
        XCTAssertNotNil(countryManager)
        
        viewModel = CountryViewViewModel(service: countryManager!)
        XCTAssertNotNil(viewModel)
        
        var topIsLoading = false
        var topStoppedLoading = false
        let promise = XCTestExpectation(description: "Top Loading Status")
        viewModel?.updateTopLoadingStatus = { stat in
            if stat { topIsLoading = stat }
            else { topStoppedLoading = stat }
            promise.fulfill()
        }
        
        // When
        viewModel?.fetchData()
        XCTAssertTrue(topIsLoading)
        XCTAssertFalse(topStoppedLoading)
        
        wait(for: [promise], timeout: 1.0)
    }
    
    func testCountryViewModel_forbotomLoadingTrue() {
        // Given
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        XCTAssertNil(viewModel)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: countryData)
        XCTAssertNotNil(countryManager)
        
        viewModel = CountryViewViewModel(service: countryManager!)
        XCTAssertNotNil(viewModel)
        
        viewModel?.fetchData()
        
        var bottomIsLoading = false
        let promise = XCTestExpectation(description: "Bottom Loading Status")
        viewModel?.updateBottomLoadingStatus = { stat in
            bottomIsLoading = stat
            promise.fulfill()
        }
        
        // When
        viewModel?.fetchMore()
        XCTAssertTrue(bottomIsLoading)
        
        wait(for: [promise], timeout: 1.0)
    }
    
    func testCountryViewModel_successfulData() {
        // Given
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        XCTAssertNil(viewModel)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: countryData)
        XCTAssertNotNil(countryManager)
        
        viewModel = CountryViewViewModel(service: countryManager!)
        XCTAssertNotNil(viewModel)
        
        var countries = [Country]()
        let promise = XCTestExpectation(description: "Successfu Fetch Countries")
        viewModel?.displayFetchedCountries = { ctrs, fetchCount in
            countries.append(contentsOf: ctrs)
            promise.fulfill()
        }
        
        // When
        viewModel?.fetchData()
        XCTAssertTrue(countries.count > 0)
    }
    
    func testCountryViewModel_failedData() {
        // Given
        XCTAssertNotNil(countryData)
        XCTAssertNil(countryManager)
        XCTAssertNil(viewModel)
        
        countryManager = MockCountryManager(requestType: RequestType.successful, mockResponse: nil)
        XCTAssertNotNil(countryManager)
        
        viewModel = CountryViewViewModel(service: countryManager!)
        XCTAssertNotNil(viewModel)
        
        var countries = [Country]()
        var message = ""
        let countryPromise = XCTestExpectation(description: "Failed To Fetch Countries")
        let messagePromise = XCTestExpectation(description: "Error Message")
        viewModel?.displayFetchedCountries = { ctrs, fetchCount in
            countries = ctrs
            countryPromise.fulfill()
        }
        
        viewModel?.displayFetchError = {msg in
            message = msg
            messagePromise.fulfill()
        }
        
        // When
        viewModel?.fetchData()
        XCTAssertTrue(countries.count == 0)
        XCTAssertTrue(message.count > 0)
        
        wait(for: [countryPromise, messagePromise], timeout: 4.0)
    }
}
