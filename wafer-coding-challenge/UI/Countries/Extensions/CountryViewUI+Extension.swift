//
//  CountryViewUI+Extension.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 23/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

extension CountryViewController: CountryCellProtocol {
    
    func deleteRow(atIndex indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        // Remove from viewmodel
        viewModel.removeCountry(country: countries[indexPath.row])
        
        // Remove from countries in controller
        countries.remove(at: indexPath.row)
        
        // Return active cell to nil.
        activeCell = nil
        
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    func currentPanningCell(cell: CountryTableViewCell) {
        if activeCell != nil && activeCell! != cell {
            activeCell?.resetPan()
            activeCell = cell
        } else { activeCell = cell }
    }
}
