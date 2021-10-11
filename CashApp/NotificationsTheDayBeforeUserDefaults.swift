//
//  NotificationsTheDayBeforeUserDefaults.swift
//  CashApp
//
//  Created by Артур on 7.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

// Уведомления, которые отправляются за день, до наступления события из планов

final class NotificationsTheDayBeforeEvent {
    
    private enum isOnNotifications: String {
        case isOn = "isOnNotifications"
    }
    
    static var isOn: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: isOnNotifications.isOn.rawValue)
        } set {
            let key = isOnNotifications.isOn.rawValue
            let defaults = UserDefaults.standard
            if let isLightTheme = newValue {
                print("value \(isLightTheme) was added to User defaults for key \(key)")
                defaults.set(isLightTheme, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
