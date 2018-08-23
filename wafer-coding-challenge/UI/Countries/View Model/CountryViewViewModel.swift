//
//  CountryViewViewModel.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import Foundation

class CountryViewViewModel {
    
    private let service: CountryManagerProtocol
    
    private var countries: [Country] = [Country]()
    private var displayCountry: (countries: [Country], fetchCount: Int) = (countries: [Country](), fetchCount: 0) {
        didSet {
            self.displayFetchedCountries?(displayCountry.countries, displayCountry.fetchCount)
        }
    }
    
    private var topIsLoading: Bool = false {
        didSet {
            self.updateTopLoadingStatus?(topIsLoading)
        }
    }
    
    private var bottomIsLoading: Bool = false {
        didSet {
            self.updateBottomLoadingStatus?(bottomIsLoading)
        }
    }
    
    private var doneFetching: Bool = false {
        didSet {
            self.fetchedAllData?(doneFetching)
        }
    }
    
    private var countryError: CountryError = .unknown {
        didSet  {
            var message = "Please, try again later. Thank You."
            switch countryError {
            case .unknown, .failedRequest, .invalidResponse:
                message = "Please, try again later. Thank You."
            }
            self.displayFetchError?(message)
        }
    }
    
    var updateTopLoadingStatus: ((Bool)->())?
    var updateBottomLoadingStatus: ((Bool)->())?
    var displayFetchedCountries: (([Country], Int)->())?
    var displayFetchError: ((String)->())?
    var fetchedAllData: ((Bool)->())?
    
    init(service: CountryManagerProtocol = CountryManager()) {
        self.service = service
        resetData()
    }
    
    private func resetData() {
        self.displayCountry = (countries: [Country](), fetchCount: 0)
        self.topIsLoading = false
        self.bottomIsLoading = false
        self.doneFetching = false
    }
    
    func fetchData() {
        self.topIsLoading = true
        service.fetchCountries { (countries, error) in
            self.topIsLoading = false
            if let error = error {
                self.resetData()
                self.countryError = error
            } else {
                if let countries = countries {
                    self.countries = countries
                    self.resetData()
                    self.processData()
                } else { self.countryError = .invalidResponse }
            }
        }
    }
    
    func fetchMore() {
        if !self.bottomIsLoading {
            self.bottomIsLoading = true
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(processData), userInfo: nil, repeats: false)
        }
    }
    
    // Default limit is 10
    @objc private func processData() {
        guard countries.count > 0 else { return }
        
        let startIndex = displayCountry.fetchCount * 10
        if startIndex >= self.countries.count {
            doneFetching = true
            return
        }
        
        var endIndex = (displayCountry.fetchCount <= 0) ? 10 : (displayCountry.fetchCount + 1) * 10
        if endIndex > self.countries.count {
            endIndex = self.countries.count
        }
        let currentData = self.countries[startIndex..<endIndex]
        let arrayCurrentData = Array(currentData)
        
        self.displayCountry = (countries: arrayCurrentData, fetchCount: (self.displayCountry.fetchCount + 1))
        self.bottomIsLoading = false
        self.topIsLoading = false
    }
    
    func removeCountry(country: Country) {
        self.countries = self.countries.filter { $0.name! != country.name! }
    }
}
