//
//  SubscriptionProductUserDefaults.swift
//  CashApp
//
//  Created by Артур on 27.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import Purchases

final class IsAvailableSubscription {
    
    private enum subscriptionKeys: String {
        case isAvailable = "isAvailable"
    }
    
    static var isAvailable: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: subscriptionKeys.isAvailable.rawValue)
        } set {
            let key = subscriptionKeys.isAvailable.rawValue
            let defaults = UserDefaults.standard
            if let available = newValue {
                print("value \(available) was added to User defaults for key \(key)")
                defaults.set(available, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
