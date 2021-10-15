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
        
        sendButtonOutlet.setImage(UIImage().getNavigationImage(systemName: "arrowtriangle.up.square.fill", pointSize: 26, weight: .light), for: .normal)
        sendButtonOutlet.tintColor = colors.titleTextColor
     
        
        receiveButtonColorSettings()
        sendButtonColorSettings()
    }
   private func receiveButtonColorSettings() {
        
        receiveButtonOutlet.backgroundColor = colors.contrastColor1
        receiveButtonOutlet.setTitleColor(colors.secondaryBackgroundColor, for: .normal)
        receiveButtonOutlet.layer.cornerRadius = 14
        receiveButtonOutlet.layer.cornerCurve = .continuous
        receiveButtonOutlet.layer.setSmallShadow(color: colors.shadowColor)
       
       receiveButtonOutlet.setImage(UIImage().getNavigationImage(systemName: "arrowtriangle.down.square.fill", pointSize: 26, weight: .light), for: .normal)
       receiveButtonOutlet.tintColor = colors.secondaryBackgroundColor
    }
    private func sendButtonColorSettings() {
        sendButtonOutlet.backgroundColor = colors.secondaryBackgroundColor
        sendButtonOutlet.setTitleColor(colors.titleTextColor, for: .normal)
        sendButtonOutlet.layer.cornerRadius = 14
        sendButtonOutlet.layer.cornerCurve = .continuous
        sendButtonOutlet.layer.setSmallShadow(color: colors.shadowColor)
    }
    
    func sendReceiveButtonsSetup(buttons: [UIButton]) {
        buttons.forEach { button in
            
        }
        
    }
}
