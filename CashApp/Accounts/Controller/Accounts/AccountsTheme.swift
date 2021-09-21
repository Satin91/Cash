//
//  AccountsTheme.swift
//  CashApp
//
//  Created by Артур on 12.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension AccountsViewController {
    
    func setColors(){
        accountsCollectionView.backgroundColor = .clear
        self.view.backgroundColor = colors.backgroundcolor
        sendReceiveButtonsSetup(buttons: [receiveButtonOutlet,sendButtonOutlet])
    }
    
    func sendReceiveButtonsSetup(buttons: [UIButton]) {
        buttons.forEach { button in
            button.backgroundColor = colors.titleTextColor
            button.setTitleColor(colors.secondaryBackgroundColor, for: .normal)
            button.layer.cornerRadius = 14
            button.layer.cornerCurve = .continuous
            button.layer.setSmallShadow(color: colors.shadowColor)
        }
        
    }
}
