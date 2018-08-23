//
//  CountryViewController.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 21/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {
    
    var numberOfRowns = 5
    var activeCell: CountryTableViewCell?
    
    struct Constants {
        static let MAIN_CELL_ID = "country_cell_identifier"
        static let DETAULT_ROW_HEIGHT: CGFloat = 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRowns
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MAIN_CELL_ID, for: indexPath) as! CountryTableViewCell
        cell.indexPath = indexPath
        cell.countryDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.DETAULT_ROW_HEIGHT
    }

}
