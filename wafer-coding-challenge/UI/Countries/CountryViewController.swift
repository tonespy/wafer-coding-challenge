//
//  CountryViewController.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    var countries: [Country] = [Country]()
    var activeCell: CountryTableViewCell?
    
    var refresher: UIRefreshControl!
    var bottomLoading: UIActivityIndicatorView!
    
    var viewModel: CountryViewViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    var doneFetchingAllData = false
    
    struct Constants {
        static let MAIN_CELL_ID = "country_cell_identifier"
        static let DETAULT_ROW_HEIGHT: CGFloat = 100
        static let TOP_PULL_TO_REFRESH_MSG = "Pull To Refresh"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.prefetchDataSource = self
        
        // Setup refresh controllers
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.gray
        refresher.attributedTitle = NSAttributedString(string: Constants.TOP_PULL_TO_REFRESH_MSG)
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.insertSubview(refresher, at: 0)
        
        bottomLoading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        bottomLoading.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        bottomLoading.center = self.view.center
        self.tableView.addSubview(bottomLoading)
        bottomLoading.bringSubview(toFront: self.tableView)
        bottomLoading.hidesWhenStopped = true
        
        viewModel = CountryViewViewModel(service: CountryManager())
        viewModel?.fetchData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MAIN_CELL_ID, for: indexPath) as! CountryTableViewCell
        cell.country = countries[indexPath.row]
        cell.indexPath = indexPath
        cell.countryDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.DETAULT_ROW_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if activeCell != nil && activeCell?.indexPath != indexPath { activeCell?.resetPan() }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.countries.count - 1) {
            if !self.doneFetchingAllData {
                guard let viewModel = viewModel else { return }
                viewModel.fetchMore()
            }
        }
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //
    }
}
