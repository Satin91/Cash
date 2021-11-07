//
//  TimeForNotifications.swift
//  CashApp
//
//  Created by Артур on 9.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation



class NotificationTime {
    
    //title одинаковый, но если потребуется их сделать особенными, это легко доступно, в файле notification они сделаны для разных свойств
    // Не забудь менять значения тайтла в NotificationMoment в файле NotificationData иначе не придут уведомления
    let titleForTommorrowNotifications = NSLocalizedString("header_notification", comment: "")
    let titleForTodayNotifications = NSLocalizedString("header_notification", comment: "")
   //body
    let bodyForTommorrowNotifications = NSLocalizedString("tommorow_notification", comment: "")
    let bodyForTodayNotifications = NSLocalizedString("today_notification", comment: "")
    //Time
    var tomorrowHour = 6 ; var tomorrowMinute = 30
    var todayHour = 10 ; var todayMinute = 30
    
    
}
