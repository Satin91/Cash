//
//  SubscriptionProductUserDefaults.swift
//  CashApp
//
//  Created by Артур on 27.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation


final class SubscribtionStatus {
    
    private enum subscriptionKeys: String {
        case isAvailable = "isAvailable"
        case trialIsActive = "trialWasActive"
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
    static var trialWasActive: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: subscriptionKeys.trialIsActive.rawValue)
        } set {
            let key = subscriptionKeys.trialIsActive.rawValue
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
