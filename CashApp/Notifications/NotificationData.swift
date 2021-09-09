//
//  NotificationData.swift
//  CashApp
//
//  Created by Артур on 9.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

struct Trigger {
    var moment: NotificationMoment
    var components: [DateComponents]
}
enum NotificationMoment: String {
    case today
    case tommorrow
    
    var rawValue: String {
        switch self {
        case .today:
            return "Today"
        case .tommorrow:
            return "Tommorrow"
        }
    }
}

class NotificationData {
    
    func compareDates(dateOfCreation: Date, secondDate: Date, moment: NotificationMoment) -> Bool {
        let dateOfCreation = dateOfCreation.getDayMonthYear()
        let second = secondDate.getDayMonthYear()
        switch moment {
        case .today:
            if dateOfCreation.day == second.day && dateOfCreation.month == second.month && dateOfCreation.year == second.year {
                return true
            }else {
                return false
            }
        case .tommorrow:
            if dateOfCreation.day == second.day! - 1 && dateOfCreation.month == second.month && dateOfCreation.year == second.year {
                return true
            }else {
                return false
            }
        }
       
    }
    func getUniqDates<T: Equatable>(components: [T]) -> [T] {
        var sequence: [T] = []
        for i in components {
            if !sequence.contains(i) {
                sequence.append(i)
            }
        }
        return sequence
    }
    
    func tommorowNotification() -> Trigger {
        var datesArray: [DateComponents] = []
       
        let enumPayPerTime = payPerTimeObjects.filter({ [weak self] (payPerTime) in
            return !self!.compareDates(dateOfCreation: payPerTime.dateOfCreation, secondDate: payPerTime.date, moment: .tommorrow)
        })
        //отфильтрованный массив который дропает те планы, которые были созданы сегодня
        let enumeratedSchedulers = EnumeratedSchedulers(object: schedulerGroup).filter({ [weak self] (scheduler) in
            return !self!.compareDates(dateOfCreation: scheduler.dateOfCreation, secondDate: scheduler.date, moment: .tommorrow)
        })
        
        enumeratedSchedulers.forEach { scheduler in
            var components = scheduler.date.getDayMonthYear()
            components.day = components.day! - 1 // Отнимает день чтобы вернуть день в который нужно отправить уведомление
                datesArray.append(components)
        }
        enumPayPerTime.forEach { payperTime in
            var components = payperTime.date.getDayMonthYear()
            components.day = components.day! - 1 // Отнимает день чтобы вернуть день в который нужно отправить уведомление
                datesArray.append(components)
        }

        let trigger = Trigger(moment: .tommorrow, components: getUniqDates(components: datesArray))
        return trigger
    }
   
   
    func todayNotification()-> Trigger {
        var datesArray: [DateComponents] = []
       
        let enumPayPerTime = payPerTimeObjects.filter({ [weak self] (payPerTime) in
            return !self!.compareDates(dateOfCreation: payPerTime.dateOfCreation, secondDate: payPerTime.date, moment: .today)
        })
        //отфильтрованный массив который дропает те планы, которые были созданы сегодня
        let enumeratedSchedulers = EnumeratedSchedulers(object: schedulerGroup).filter({ [weak self] (scheduler) in
            return !self!.compareDates(dateOfCreation: scheduler.dateOfCreation, secondDate: scheduler.date, moment: .today)
        })
        enumeratedSchedulers.forEach { date in
            let components = date.date.getDayMonthYear()
                datesArray.append(components)
        }
        enumPayPerTime.forEach { payperTime in
            let components = payperTime.date.getDayMonthYear()
                datesArray.append(components)
        }

        let trigger = Trigger(moment: .today, components: getUniqDates(components: datesArray))
        return trigger
    }
    
    
}
