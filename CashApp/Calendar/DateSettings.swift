//
//  DateSettings.swift
//  CashApp
//
//  Created by Артур on 9/30/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit


//
let dateCalendar = Calendar.current

let someDateComponentsEx = DateComponents()//Экземпляр класса компонентов

let someDateFormatterEx = DateFormatter() //Экземпляр класса фотматов

let someDateComponents = DateComponents(year: 2020, month: 10, day: 5) // Пример создания компонентов даты

let someDateOfComponents = dateCalendar.date(from: someDateComponents)// Требует компоненты, получили дату.

let dateComponentsNow = dateCalendar.dateComponents([.year, .month ,.day], from: someDateOfComponents!)//Требует дату, получили компонетны.

let todayDate = Date()

let stringOnDataComponents = someDateFormatterEx.string(from: someDateOfComponents!)

///Так как нельзя в класе инициилизировать объекты, я создам функцию

func fullDateToString(date: Date) -> String {
    let format = Calendar.current.component(.year, from: date)
    let currentFormat = Calendar.current.component(.year, from: Date())
    if currentFormat != format {
        someDateFormatterEx.dateFormat = "MMMM, d, yyyy"
        
    }else {
        someDateFormatterEx.dateFormat = "MMMM, d"
    }
    let returnString = someDateFormatterEx.string(from: date)
    return returnString
}

///Дата в текст
func dateToString(date: Date) -> String {
    let someDateFormatterEx = DateFormatter()
    let format = Calendar.current.component(.year, from: date)
    let currentFormat = Calendar.current.component(.year, from: Date())
    if date.thisDayisToday() {
        return NSLocalizedString("day_is_today", comment: "")
    }else if date.thisDayWasEstereday() {
        return NSLocalizedString("day_was_yestereday", comment: "")
    }else if  currentFormat != format {
        someDateFormatterEx.dateFormat = NSLocalizedString("year_does_not_coincide", comment: "")
    }else {
        someDateFormatterEx.dateFormat = NSLocalizedString("year_coincides", comment: "")
    }
    let returnString = someDateFormatterEx.string(from: date)
    return returnString
}

///Компоненты в текст
func componentsToString(date Components: DateComponents) -> String {
    someDateFormatterEx.dateFormat = "MMM, d, Y"
    
     let date = dateCalendar.date(from: Components)
    let returnString = someDateFormatterEx.string(from: date!)
    return returnString
}

extension Date {
    func thisDayisToday() -> Bool {
        let today =  Calendar.current.component(.day, from: Date())
        let day = Calendar.current.component(.day, from: self)
        if today == day {
            return true
        }else{
            return false
        }
    }
    func thisDayWasEstereday() -> Bool {
        let today =  Calendar.current.component(.day, from: Date())
        let day = Calendar.current.component(.day, from: self)
        if day == today - 1 {
            return true
        }else{
            return false
        }
    }
}
