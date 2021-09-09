//
//  Calendar.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//
import FSCalendar
import Foundation

extension TodayBalanceViewController: FSCalendarDelegateAppearance,FSCalendarDelegate,FSCalendarDataSource {
    
    func updateDatesArray() ->[Date]  {
        let datesArray: [Date] = {
            var dates = [Date]()
            for i in payPerTimeObjects{
                dates.append(i.date)
            }
            for x in Array(oneTimeObjects) {
                dates.append(x.date)
            }
            for y in Array(goalObjects) {
                dates.append(y.date)
            }
            return dates
        }()
        return datesArray
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // let a = uniq(source: datesArray)
        let datesArray: [Date] = updateDatesArray()
        if datesArray.contains(date) {
            return 1
            
        }else{
            return 0
        }
        
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //Так как создается баланс только при выборе даты, эту конструкцию нужно указывать только здесь
        do {
            try todayBalanceObject = DBManager.fetchTB(date: date)
        } catch let error {
            try! realm.write {
                realm.add(TodayBalance(commonBalance: 0, currentBalance: 0, endDate: date))
            }
            print (error.localizedDescription)
        }
        endDate = date
        updateTotalBalanceSum(animated: true)
        self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView2(animatedView: calendarContainerView)
        self.view.reservedAnimateView2(animatedView: self.calendar)
    }
    
    
    
}
