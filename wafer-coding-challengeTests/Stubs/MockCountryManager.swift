//
//  MockCountryManager.swift
//  wafer-coding-challengeTests
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import XCTest
@testable import wafer_coding_challenge

enum RequestType: Error {
    
    case successful
    case unknown
    case failedRequest
    case invalidResponse
}

class MockCountryManager: CountryManagerProtocol {
    
    // MARK: - Properties
    private let requestType: RequestType
    private let mockResponse: Data?
    
    init(requestType: RequestType, mockResponse: Data?) {
        self.requestType = requestType
        self.mockResponse = mockResponse
    }
    
    func fetchCountries(completion: @escaping CountryManagerProtocol.FetchCountryCompletion) {
        switch requestType {
        case.successful:
            guard let data = mockResponse else {
                completion(nil, .invalidResponse)
                return
            }
            
            do {
                // Decode JSON
                let decoder = JSONDecoder()
                let countries = try decoder.decode([Country].self, from: data)
                
                // Invoke Completion Handler
                completion(countries, nil)
            } catch {
                // Invoke Completion Handler
                completion(nil, .invalidResponse)
            }
        case .unknown:
            completion(nil, .unknown)
        case .failedRequest:
            completion(nil, .failedRequest)
        case .invalidResponse:
            completion(nil, .invalidResponse)
        }
    }
}
