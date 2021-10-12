//
//  QuickPayTheme.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import Themer

extension QuickPayViewController {
    func setColors(){
        colors.loadColors()
        //self.accountLabel.textColor = colors.subtitleTextColor
        self.sumTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: colors.borderColor ])
        self.view.backgroundColor = colors.backgroundcolor
        containerView.backgroundColor = .clear
        containerView.layer.setSmallShadow(color: colors.shadowColor)
        
       // Themer.shared.register(target: self, action: QuickPayViewController.theme(_:))
    }

    
}
