//
//  CountryTableViewViewModel.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 23/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import Foundation

class CountryTableViewViewModel {
    
    private let country: Country
    
    var displayName: ((String)->())?
    var displayCurrency: ((String)->())?
    var displayLanguage: ((String)->())?
    
    init(withCountry country: Country) {
        self.country = country
    }
    
    func setupModel() {
        if let countryName = country.name {
            displayName?(countryName)
        } else { displayName?("N/A") }
        
        if let currencies = country.currencies, currencies.count > 0, let currencyName = currencies[0].name {
            displayCurrency?(currencyName)
        } else { displayCurrency?("N/A") }
        
        if let languages = country.languages, languages.count > 0, let languageName = languages[0].name {
            displayLanguage?(languageName)
        } else { displayLanguage?("N/A") }
    }
}
