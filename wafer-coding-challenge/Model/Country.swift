//
//  Country.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import Foundation

/// Country Model would contain information about three variables:
///
///     Name: Name of the country
///     Currenries: Accepted currencies in the country
///     Languages: Approved Languages in the country
struct Country: Codable {
    
    let name: String?
    let currencies: [Currency]?
    let languages: [Language]?
}

/// Currency Model would contain information about three variables:
///
///     code: 3-digit abreviated letter of the currency
///     name: Full Name of the currency
///     symbol: Currencies symbol
struct Currency: Codable {
    
    let code: String?
    let name: String?
    let symbol: String?
}

/// Language Model would contain information about four variables:
///
///     code: 3-digit abreviated letter of the currency
///     name: Full Name of the currency
///     symbol: Currencies symbol
struct Language: Codable {
    
    let iso639_1: String?
    let iso639_2: String?
    let name: String?
    let nativeName: String?
}
