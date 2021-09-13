//
//  AddAccountTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension AddAccountViewController {
    
    func setColors(){
        self.view.backgroundColor = colors.backgroundcolor
        headingTextLabel.textColor = colors.titleTextColor
        nameTextField.borderedTheme(fillColor: colors.secondaryBackgroundColor, shadowColor: colors.shadowColor)
        
        balanceTextField.borderedTheme(fillColor: colors.secondaryBackgroundColor, shadowColor: colors.shadowColor)
    }
}
