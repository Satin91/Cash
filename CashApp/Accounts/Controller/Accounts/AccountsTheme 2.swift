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
       // sendReceiveButtonsSetup(buttons: [receiveButtonOutlet,sendButtonOutlet])
        
        
     
        transferButtonsSetup(buttons: [sendButtonOutlet,receiveButtonOutlet])
        receiveButtonColorSettings()
        sendButtonColorSettings()
    }
    func transferButtonsSetup(buttons: [UIButton]) {
        buttons.forEach { btn in
            btn.backgroundColor = colors.secondaryBackgroundColor
            btn.setTitleColor(colors.titleTextColor, for: .normal)
            btn.layer.cornerRadius = (btn.bounds.height * 0.38) * 0.62
            btn.layer.cornerCurve = .continuous
            btn.layer.setSmallShadow(color: colors.shadowColor)
        }
    }
   private func receiveButtonColorSettings() {
       receiveButtonOutlet.setImage(UIImage().getNavigationImage(systemName: "arrow.down.circle.fill", pointSize: 28, weight: .regular), for: .normal)
       receiveButtonOutlet.setTitle("", for: .normal)
       receiveButtonOutlet.tintColor = colors.contrastColor1
    }
    private func sendButtonColorSettings() {
        sendButtonOutlet.setImage(UIImage().getNavigationImage(systemName: "arrow.up.circle.fill", pointSize: 28, weight: .regular), for: .normal)
        sendButtonOutlet.tintColor = colors.redColor
        sendButtonOutlet.setTitle(NSLocalizedString("accounts_transfer_send", comment: ""), for: .normal)
    }
    
    func sendReceiveButtonsSetup(buttons: [UIButton]) {
        buttons.forEach { button in
            
        }
        
    }
}
