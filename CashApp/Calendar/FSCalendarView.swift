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
        
    }
    
    func calendarSettings() {
        
        
//        calendarView.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "D", options: 0, locale: .current)
//        self.appearance.titleTodayColor = whiteThemeBackground
//        self.appearance.titleDefaultColor = ThemeManager2.currentTheme().titleTextColor
//        self.appearance.titleWeekendColor = ThemeManager2.currentTheme().contrastColor1
//        self.appearance.headerTitleColor = ThemeManager2.currentTheme().contrastColor1
//        self.appearance.weekdayTextColor = ThemeManager2.currentTheme().subtitleTextColor
        self.scrollDirection = .vertical
        self.setColors()
        self.firstWeekday = 2
        self.placeholderType = .fillSixRows
        self.appearance.titleFont = .systemFont(ofSize: 17, weight: .medium)
        self.appearance.headerTitleAlignment = .left
        //self.appearance.headerTitleOffset = .init(x: 26, y: 0)
        self.headerHeight = self.bounds.height / 5
        self.appearance.headerTitleFont = .systemFont(ofSize: 56, weight: .light)
        self.appearance.headerMinimumDissolvedAlpha = 0
        
        let label = UILabel()
        label.backgroundColor = .black
        
        
        
        
        
        
        
        self.appearance.headerDateFormat = "LLLL"
        
        
            //self.calendarWeekdayView.bounds.inset(by: UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26) )
        
        self.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
        //self.appearance.headerTitleOffset = .init(x: 26, y: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        calendarSettings()
      
      //  fatalError("init(coder:) has not been implemented")
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0.5
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
