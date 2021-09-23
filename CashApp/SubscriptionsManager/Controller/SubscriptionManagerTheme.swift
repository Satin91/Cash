//
//  SubscriptionManagerTheme.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import Themer

extension SubscriptionsManagerViewController {
    
    
    func setColors() {
        self.colors.loadColors()
        self.view.backgroundColor = colors.backgroundcolor
        self.tableView.backgroundColor = .clear
        
    }
}
