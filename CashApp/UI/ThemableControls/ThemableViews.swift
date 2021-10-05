//
//  ThemableViews.swift
//  CashApp
//
//  Created by Артур on 2.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
import Themer
import FSCalendar


class ThemableSecondaryView: UIView {
    override func didMoveToWindow() {
        Themer.shared.register(target: self, action: ThemableSecondaryView.theme(_:))
        super.didMoveToWindow()
    }
    func theme(_ theme: MyTheme) {
        backgroundColor = theme.settings.secondaryBackgroundColor
        layer.setSmallShadow(color: theme.settings.shadowColor)
    }
}
class ThemableImageView: UIImageView {
    override func didMoveToWindow() {
        Themer.shared.register(target: self, action: ThemableImageView.theme(_:))
        self.image = UIImage(named: "AppIcon")
        super.didMoveToWindow()
    }
    func theme(_ theme: MyTheme) {
        self.changePngColorTo(color: theme.settings.titleTextColor)
    }
}



extension FSCalendarView {
    
    func theme(_ theme:MyTheme){
        self.appearance.titleTodayColor = theme.settings.titleTextColor
        self.appearance.todayColor = .clear
        self.appearance.titleDefaultColor = theme.settings.titleTextColor
        self.appearance.titleWeekendColor = theme.settings.contrastColor1
        self.appearance.headerTitleColor = theme.settings.titleTextColor
        self.appearance.weekdayTextColor = theme.settings.subtitleTextColor
        self.appearance.selectionColor = theme.settings.redColor
        
        self.backgroundColor = theme.settings.secondaryBackgroundColor
        // self.layer.setMiddleShadow(color: theme.settings.shadowColor)
        
        self.appearance.eventDefaultColor = theme.settings.contrastColor1
        //self.calendarHeaderView.backgroundColor = theme.settings.borderColor
        //self.calendarWeekdayView.backgroundColor = theme.settings.titleTextColor
        
    }
    func setColors() {
        Themer.shared.register(target: self, action: FSCalendarView.theme(_:))
    }
}


