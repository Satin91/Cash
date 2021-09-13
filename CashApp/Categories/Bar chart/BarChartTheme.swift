//
//  BarChartTheme.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation

extension BarChartViewController {
    
    func setColors() {
        segmentedControl.backgroundColor = colors.secondaryBackgroundColor
        self.view.backgroundColor = colors.backgroundcolor
        tableView.backgroundColor = .clear
        
    }
}
