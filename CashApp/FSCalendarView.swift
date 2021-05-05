//
//  FSCalendarView.swift
//  CashApp
//
//  Created by Артур on 17.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
class FSCalendarView: FSCalendar, FSCalendarDelegateAppearance {

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        calendarSettings()
        self.scrollDirection = .vertical
        
    }
    
    func calendarSettings() {
        self.appearance.titlePlaceholderColor = whiteThemeTranslucentText
        
//        calendarView.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "D", options: 0, locale: .current)
        self.appearance.titleTodayColor = whiteThemeBackground
        self.appearance.titleDefaultColor = whiteThemeMainText
        self.appearance.titleWeekendColor = whiteThemeRed
        self.appearance.headerTitleColor = whiteThemeRed
        self.appearance.weekdayTextColor = whiteThemeTranslucentText
        self.firstWeekday = 2
        self.placeholderType = .none
        self.appearance.titleFont = .monospacedSystemFont(ofSize: 17, weight: UIFont.Weight.regular)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0.5
    }
}
