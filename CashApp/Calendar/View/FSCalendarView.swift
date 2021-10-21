//
//  FSCalendarView.swift
//  CashApp
//
//  Created by Артур on 17.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
enum CalendarType {
    case regular
    case mini
}


class FSCalendarView: FSCalendar, FSCalendarDelegateAppearance {
    
    var calendarType = CalendarType.mini
    let colors = AppColors()
    init(frame: CGRect, calendarType: CalendarType) {
        super.init(frame: frame)
        self.calendarType = calendarType
    }
    // Вместо того чтобы поместить методы в requer init я поместил сюда потому что календарь в Calendar scheduler находится в сториборде и по умолчанию устанавливает дефолтное значение calendar type = mini
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.colors.loadColors()
        calendarSettings()
        setHeaderHeight()
     //   calendarLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        calendarSettings()
        setHeaderHeight()
     //   calendarLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setHeaderLeftInset()
        setHeaderHeight()
    }
    

    func setHeaderHeight() {
        switch calendarType {
        case .regular:
            self.headerHeight = self.bounds.height / 5
            self.appearance.headerTitleAlignment = .left
            self.appearance.headerTitleFont = .systemFont(ofSize: 46, weight: .semibold)
            self.appearance.titleFont = .systemFont(ofSize: 17, weight: .medium)
            
            
        case .mini:
            self.headerHeight = self.bounds.height / 7
            self.appearance.headerTitleAlignment = .left
            self.appearance.headerTitleFont = .systemFont(ofSize: 34, weight: .regular)
            self.appearance.titleFont = .systemFont(ofSize: 17, weight: .regular)
            self.calendarWeekdayView.backgroundColor = colors.backgroundcolor
            self.appearance.weekdayTextColor = colors.subtitleTextColor
        }
    }
    func setHeaderLeftInset() {
        if self.calendarType == .mini {
        self.calendarHeaderView.frame = calendarHeaderView.bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0) )
        }
    }
    func calendarLayout() {
        let height: CGFloat = 860
        var bottomInset: CGFloat
        if self.bounds.height >= height {
            bottomInset = self.bounds.height - height
        } else {
         bottomInset = 20
        }
            //self.calendarWeekdayView.bounds.inset(by: UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26) )
        self.collectionViewLayout.sectionInsets = UIEdgeInsets(top: 20, left: 0, bottom: bottomInset, right: 0)
    }
     func calendarSettings() {
         self.scrollDirection = .vertical
        self.setColors() // Устанавливает цвета из расширения в ThemableViews
        self.firstWeekday = 2
        self.appearance.headerMinimumDissolvedAlpha = 0
        self.placeholderType = .none
        
        self.appearance.headerDateFormat = "LLLL, yyyy"
    }
    
   
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
//        return 0.1
//    }
}
