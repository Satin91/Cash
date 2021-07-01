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

///Дата в текст
func dateToString(date: Date) -> String {
    
    let format = Calendar.current.component(.year, from: date)
    let currentFormat = Calendar.current.component(.year, from: Date())
    if currentFormat != format {
        someDateFormatterEx.dateFormat = "MMM, d, Y"
        
    }else {
        someDateFormatterEx.dateFormat = "MMM, d"
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

