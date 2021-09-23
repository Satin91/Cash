//
//  CalculatePayPerTimeParts.swift
//  CashApp
//
//  Created by Артур on 23.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CalculatePayPerTimeParts {
    
    
//    func getParts1() {
//        var scheduleID: String?// Местная переменная для исключения повторов
//
//        struct payPerSumAndID {
//            var schedulerID: String
//            var schedulerPayPerTime: Double
//            var date: Date
//        }
//
//        var totalPayPerSum: [payPerSumAndID] = [] // переменная для подсчета общей суммы разовых платежей
//        var counter = 0
//
//        //подсчет суммы для разовых платежей
//
//
//        for i in payPerTimeObjects {
//            print(i.scheduleID)
//            if i.scheduleID != scheduleID{
//                counter += 1
//                totalPayPerSum.append(payPerSumAndID(schedulerID: i.scheduleID , schedulerPayPerTime: i.target, date: i.date))
//                scheduleID = i.scheduleID
//            }else{
//                if i.date <= todayBalanceObject!.endDate {
//                    totalPayPerSum[counter - 1].schedulerPayPerTime += i.target
//                    totalPayPerSum[counter - 1].date = i.date
//                }
//            }
//        }
//        //Рассчет дневной суммы для корректировки бюджета
//        counter = 0
//        for i in totalPayPerSum {
//
//            totalPayPerSum[counter].schedulerPayPerTime = i.schedulerPayPerTime / Double(divider)
//            print(i.schedulerPayPerTime / Double(divider))
//            counter += 1
//        }
//        counter = 0
//        scheduleID = nil
//        for i in payPerTimeObjects { //Сортировка обязательна, иначе он беспорядочно добавить миллион ячеек
//            if i.date <= todayBalanceObject!.endDate && !sschedulerArray.contains(where: { schedulerForTalbeView in
//                schedulerForTalbeView.scheduler.name == i.scheduleName
//            }) {
//                for scheduler in EnumeratedSchedulers(object: schedulerGroup) {
//                    if i.scheduleID == scheduler.scheduleID && i.scheduleID != scheduleID {
//                        sschedulerArray.append(SchedulersForTableView(scheduler: scheduler, todaySum: totalPayPerSum[counter].schedulerPayPerTime) )
//                        counter += 1
//                        scheduleID = scheduler.scheduleID
//                    }else{
//                        continue
//                    }
//                }
//            }
//        }
//
//    }
    
    struct payPerTimeSorted {
        var scheduleID: String
        var totalSum: Double
    }
    
    func getUniq(endDate: Date,divider: Int) -> [String]{
    //
        var uniqSchedulerIDs: [String] = []
        //запись все
        for i in payPerTimeObjects where i.date <= endDate{
            if !uniqSchedulerIDs.contains(where: { id in
                id == i.scheduleID
            }) {
                uniqSchedulerIDs.append(i.scheduleID)
            }
        }
        
        return uniqSchedulerIDs
    }
    
    func getParts(endDate: Date,divider: Int) -> [SchedulersForTableView] {
      let uniq = getUniq(endDate: endDate, divider: divider)
//        var array = [payPerTimeSorted]()
  //      var single = payPerTimeSorted(scheduleID: "", totalSum: 0)
        var totalSum: Double = 0
        var schedulersForTableView: [SchedulersForTableView] = []
        var validPayPerTime: [PayPerTime] = []
        for value in payPerTimeObjects where value.date <= endDate && uniq.contains(value.scheduleID){
            validPayPerTime.append(value)//Определили все единичные оплаты в рамках даты
        }
        var schedulerID = String()
        for index in uniq{
            for valid in validPayPerTime {
                if valid.scheduleID == index {
                    totalSum += valid.target
                    schedulerID = index
                }
            }
            schedulersForTableView.append(SchedulersForTableView(scheduler:findSchedulerAtSchedulerID(scheduleID: schedulerID) , todaySum: totalSum / Double(divider)))
            totalSum = 0
            print(totalSum)
        }
        
     return schedulersForTableView
    }
    
    func findSchedulerAtSchedulerID(scheduleID: String) -> MonetaryScheduler{
        for i in EnumeratedSchedulers(object: schedulerGroup){
            if i.scheduleID == scheduleID {
                return i
            }
        }
        return MonetaryScheduler()
    }
}

