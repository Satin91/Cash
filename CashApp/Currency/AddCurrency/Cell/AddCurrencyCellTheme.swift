//
//  AddCurrencyCellTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation

extension AddCurrencyTableViewCell {
 
    func setCellColors() {
        
        self.contentView.backgroundColor = colors.secondaryBackgroundColor
        self.backgroundColor = colors.backgroundcolor
        self.contentView.layer.setSmallShadow(color: colors.shadowColor)
        self.descriptionLabel.textColor = colors.titleTextColor
    }
}
