//
//  Notifications.swift
//  CashApp
//
//  Created by Артур on 8.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationTime = NotificationTime()
    let data = NotificationData()
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            guard granted else {return}
            self.getNotificationSettings()
        }
    }

   
    func sendNotifications(){
        scheduleNotification(trigger: data.todayNotification())
        print("sendNotifications")
        guard NotificationsTheDayBeforeEvent.isOn == true else { return }
        print("tommorowNotification")
        scheduleNotification(trigger: data.tommorowNotification())
    }
    
    func contentForNotificationRequest(moment: NotificationMoment) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = moment == .today ?  notificationTime.titleForTodayNotifications : notificationTime.titleForTommorrowNotifications
        content.body = moment == .today ?  notificationTime.bodyForTodayNotifications : notificationTime.bodyForTommorrowNotifications
        content.badge = 0
        content.sound = UNNotificationSound.default
        return content
    }
    func componentsForNotificationTrigger(moment: NotificationMoment, components: DateComponents) -> DateComponents{
        var components = components
        components.day = components.day!
        components.hour! = moment == .today ?  notificationTime.todayHour : notificationTime.tomorrowHour
        components.minute  = moment == .today ? notificationTime.todayMinute : notificationTime.tomorrowMinute
        return components
    }
    func generateIDFrom(components: DateComponents) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = Calendar.current.date(from: components)
        let id = formatter.string(from: date!)
        return id
    }
    func scheduleNotification(trigger: Trigger){
        notificationCenter.removeAllDeliveredNotifications()
        for i in trigger.components {
            let components = componentsForNotificationTrigger(moment: trigger.moment, components: i)
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let content = contentForNotificationRequest(moment: trigger.moment)
            let id = generateIDFrom(components: components) + trigger.moment.rawValue
            let request = UNNotificationRequest(identifier: id , content: content, trigger: notificationTrigger)
            notificationCenter.add(request) { error in
                if let err = error {
                    print("error\(err)")
                }
            }
        }
    }
    func getNotificationSettings(){
        notificationCenter.getNotificationSettings { (settings) in
        }
    }
    
    

    //MARK: - Notification center delegate(Действия при нажатии на уведомление)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.sound ])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local notification" {
            
            
//            let schedulerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "schedulerVC") as! SchedulerViewController
//            let rootViewController = UINavigationController(rootViewController: schedulerVC)
//
//            UIApplication.shared.windows.first?.rootViewController = rootViewController
//
//
        }
        completionHandler()
    }
}
