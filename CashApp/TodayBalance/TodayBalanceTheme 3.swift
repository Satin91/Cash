//
//  TodayBalanceTheme.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


extension TodayBalanceViewController {
    
    func setColors(){
        
        self.view.backgroundColor = colors.backgroundcolor
        containerView.backgroundColor = colors.secondaryBackgroundColor
        containerView.layer.setMiddleShadow(color: colors.shadowColor)
        
        containerForTableView.backgroundColor = colors.secondaryBackgroundColor
        containerForTableView.layer.setMiddleShadow(color:colors.shadowColor)
        calendarButtonOutlet.backgroundColor = colors.contrastColor1
        //labels
        dailyBudgetLabel.textColor = colors.titleTextColor
        calculatedUntilDateLabel.textColor = colors.subtitleTextColor
        dailyBudgetBalanceLabel.textColor = colors.titleTextColor
    
        impactOnBalanceLabel.textColor = colors.titleTextColor
        
        circleBarContainerView.layer.setSmallShadow(color: colors.shadowColor)
        circleBarContainerView.backgroundColor = colors.secondaryBackgroundColor
}
}
