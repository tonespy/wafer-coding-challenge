//
//  CountryManager.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import Foundation

enum CountryError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
}

protocol CountryManagerProtocol {
    
    typealias FetchCountryCompletion = ([Country]?, CountryError?) -> ()
    
    func fetchCountries(completion: @escaping FetchCountryCompletion)
}

class CountryManager: CountryManagerProtocol {
    
    // MARK: - Properties
    private let baseURL: URL
    
    // MARK: - Initialization
    init() {
        self.baseURL = URL(string: String.BASE_URL)!
    }
    
    // MARK: - Country Manager Protocol
    func fetchCountries(completion: @escaping CountryManagerProtocol.FetchCountryCompletion) {
        
        // Create Data Task
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            DispatchQueue.main.sync {
                self.processCountryData(data: data, response: response, error: error, completion: completion)
            }
        }.resume()
    }
    
    // MARK: - Process data
    private func processCountryData(data: Data?, response: URLResponse?, error: Error?, completion: @escaping CountryManagerProtocol.FetchCountryCompletion) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
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
            } else {
                completion(nil, .failedRequest)
            }
        } else {
            completion(nil, .unknown)
        }
    }
}
