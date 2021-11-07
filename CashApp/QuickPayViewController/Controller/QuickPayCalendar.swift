//
//  QuickPayCalendar.swift
//  CashApp
//
//  Created by Артур on 4.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
///MARK: Calendar
extension QuickPayViewController: FSCalendarDelegate {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.date = date
        dateLabel.text = dateToString(date: date)
        returnToCenter.returnToCenterWithDelay(scrollView: self.scrollView)
    }
}
