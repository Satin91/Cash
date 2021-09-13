//
//  AddCurrencyTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension AddCurrencyTableViewController {
    
    
    func setColors(){
        
        searchController.searchBar.tintColor = ThemeManager2.currentTheme().borderColor
        tableView.backgroundColor = colors.backgroundcolor
    }
}
