//
//  SubscriptionManager.swift
//  CashApp
//
//  Created by Артур on 21.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionManager: NSObject  {

    enum MonetaryObjectType: Int {
        case accounts
        case plans
        case categories
        case currencies
        var count: Int {
            switch self {
            case .accounts:
                return 2
            case .plans:
                return 1
            case .categories:
                return 4
            case .currencies:
                return 2
            }
        }
    }
    
    func allowedNumberOfCells(objectsCountFor: MonetaryObjectType) -> Int {
        // check value from userDefalts and set its to UserDefaults
        let isActive = UserDefaults.standard.bool(forKey: "isAvailable")
        if isActive == true {
            return 1000
        } else {
            return objectsCountFor.count
        }
    }
}
