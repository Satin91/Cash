//
//  AppColors.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Themer
import FSCalendar

class AppColors{

    func loadColors() {
        Themer.shared.register(target: self, action: AppColors.theme(_:))
    }
     var backgroundcolor: UIColor = .clear
     var secondaryBackgroundColor: UIColor = .clear
     var titleTextColor: UIColor = .clear
     var subtitleTextColor: UIColor = .clear
     var contrastColor1: UIColor = .clear
     var contrastColor2: UIColor = .clear
     var redColor: UIColor = .clear
     var greenColor: UIColor = .clear
     var yellowColor: UIColor = .clear
     var borderColor:UIColor = .clear
     var separatorColor:UIColor = .clear
     var shadowColor:UIColor = .clear
     var whiteColor: UIColor = .clear
    
    private func theme(_ theme: MyTheme) {
        backgroundcolor = theme.settings.backgroundColor
        secondaryBackgroundColor = theme.settings.secondaryBackgroundColor
        titleTextColor = theme.settings.titleTextColor
        subtitleTextColor = theme.settings.subtitleTextColor
        contrastColor1 = theme.settings.contrastColor1
        contrastColor2 = theme.settings.contrastColor2
        redColor = theme.settings.redColor
        greenColor = theme.settings.greenColor
        yellowColor = theme.settings.yellowColor
        borderColor = theme.settings.borderColor
        separatorColor = theme.settings.separatorColor
        shadowColor = theme.settings.shadowColor
        whiteColor = UIColor.white
    }
}
