//
//  CountryViewUIViewModel+Extension.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 23/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

extension CountryViewController {
    
    func setupViewModel() {
        if !isViewLoaded { return }
        
        guard let viewModel = viewModel else { return  }
        
        viewModel.displayFetchedCountries = { ctrs, fetchCount in
            if fetchCount == 1 {
                self.countries = ctrs
            } else {
                self.countries += ctrs
            }
            self.tableView.reloadData()
        }
        
        viewModel.displayFetchError = { message in
            self.showAlert("Alert!!!", body: message)
        }
        
        viewModel.updateTopLoadingStatus = { stat in
            if stat { self.refresher.beginRefreshing() }
            else { self.refresher.endRefreshing() }
        }
        
        viewModel.updateBottomLoadingStatus = { stat in
            if stat { self.bottomLoading.startAnimating() }
            else { self.bottomLoading.stopAnimating() }
        }
        
        viewModel.fetchedAllData = { stat in
            self.doneFetchingAllData = stat
        }
    }
    
    @objc func refresh() {
        guard let viewModel = viewModel else { return }
        viewModel.fetchData()
    }
}
