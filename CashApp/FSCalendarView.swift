//
//  FSCalendarView.swift
//  CashApp
//
//  Created by Артур on 17.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
class FSCalendarView: UIView {

    var calendarView: FSCalendar!
    override init(frame: CGRect) {
        super.init(frame: frame)
        calendarView = FSCalendar(frame: frame)
        calendarSettings()
        calendarView.scrollDirection = .vertical
        self.addSubview(calendarView)
        initConstraints(view: calendarView, to: self)
    }
    
    func calendarSettings() {
        calendarView.appearance.titlePlaceholderColor = whiteThemeTranslucentText
        
//        calendarView.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "D", options: 0, locale: .current)
        calendarView.appearance.titleTodayColor = whiteThemeBackground
        calendarView.appearance.titleDefaultColor = whiteThemeMainText
        calendarView.appearance.titleWeekendColor = whiteThemeRed
        calendarView.appearance.headerTitleColor = whiteThemeRed
        calendarView.appearance.weekdayTextColor = whiteThemeTranslucentText
        calendarView.firstWeekday = 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
