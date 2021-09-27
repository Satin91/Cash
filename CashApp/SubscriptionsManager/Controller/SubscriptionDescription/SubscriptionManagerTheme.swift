//
//  SubscriptionManagerTheme.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

extension SubscriptionsManagerViewController {
    
    
    func setColors() {
        self.colors.loadColors()
        self.view.backgroundColor = colors.backgroundcolor
        
        self.subscriptionButton.backgroundColor = colors.redColor
        self.subscriptionButton.setTitleColor(colors.secondaryBackgroundColor, for: .normal)
        self.restoreButtonOutlet.backgroundColor = .clear
        self.restoreButtonOutlet.setTitleColor(colors.contrastColor1, for: .normal)
        self.unlimitImageView.setImageColor(color: colors.redColor)
        self.notificationImageView.setImageColor(color: colors.redColor)
        self.unlimitLabel.textColor = colors.titleTextColor
        self.notificationLabel.textColor = colors.titleTextColor
        self.notificationDescription.textColor = colors.subtitleTextColor
        self.unlimitDescription.textColor = colors.subtitleTextColor
        self.containerView.backgroundColor = colors.secondaryBackgroundColor.withAlphaComponent(0.8)
    }
    func visualSettings() {
        subscriptionButton.layer.cornerRadius = 12
        subscriptionButton.layer.cornerCurve = .continuous
        subscriptionButton.layer.setSmallShadow(color: colors.shadowColor)
        containerView.layer.cornerRadius = 25
       // setGradientBackground()
    }
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}
