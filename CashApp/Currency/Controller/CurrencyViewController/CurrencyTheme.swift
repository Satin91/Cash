//
//  CurrencyTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
extension CurrencyViewController {
    func setColors() {
        self.view.backgroundColor = colors.backgroundcolor
        currencyConverterTextField.borderedTheme(fillColor: colors.secondaryBackgroundColor, shadowColor: colors.shadowColor)
        currencyConverterLabel.textColor = colors.titleTextColor
    }
}
