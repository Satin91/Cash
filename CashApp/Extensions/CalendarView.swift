//
//  CalendarView.swift
//  CashApp
//
//  Created by Артур on 9/30/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar
class CalendarView: FSCalendar,FSCalendarDelegate,FSCalendarDataSource {
    
}


extension FSCalendar {
    
    func changeColorTheme(Calendar: FSCalendar) {
        let calendar = Calendar
        
        calendar.scrollDirection = .horizontal
        calendar.backgroundColor = whiteThemeBackground
        calendar.layer.cornerRadius = 18
        calendar.allowsSelection = true
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.firstWeekday = 2
        calendar.appearance.titleDefaultColor = whiteThemeMainText
        calendar.appearance.titleSelectionColor = whiteThemeBackground
        calendar.appearance.titlePlaceholderColor = whiteThemeTranslucentText
        
        calendar.setScope(.week, animated: true)
        
    }
}
protocol calendarSettings:FSCalendarDelegate {
    
}

