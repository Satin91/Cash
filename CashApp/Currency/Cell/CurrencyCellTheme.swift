//
//  CurrencyCellTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension CurrencyTableViewCell {
    
    func setCellColors(){
        
        contentView.backgroundColor = colors.secondaryBackgroundColor
        contentView.layer.setSmallShadow(color: colors.shadowColor)
        
        ISOLabel.textColor = colors.subtitleTextColor
        isMainCurrencyLabel.textColor = colors.subtitleTextColor
        currencyDescriptionLabel.textColor = colors.titleTextColor
        currencyImage.layer.borderColor = colors.backgroundcolor.cgColor
        
    }
}

