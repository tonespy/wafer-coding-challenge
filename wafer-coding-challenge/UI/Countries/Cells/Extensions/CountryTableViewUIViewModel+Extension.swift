//
//  CountryTableViewUIViewModel+Extension.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 23/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

extension CountryTableViewCell {
    
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.displayCurrency = { currency in
            self.currencyLabel.text = currency
        }
        
        viewModel.displayName = { name in
            self.nameLabel.text = name
        }
        
        viewModel.displayLanguage = { language in
            self.languageLabel.text = language
        }
    }
}
