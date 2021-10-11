//
//  ThemeUserDefaults.swift
//  CashApp
//
//  Created by Артур on 7.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import Themer
final class IsLightTheme {
    
    private enum themeKeys: String {
        case isLightTheme = "isLightTheme"
    }
    
    static var isLightTheme: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: themeKeys.isLightTheme.rawValue)
        } set {
            let key = themeKeys.isLightTheme.rawValue
            let defaults = UserDefaults.standard
            if let isLightTheme = newValue {
                print("value \(isLightTheme) was added to User defaults for key \(key)")
                defaults.set(isLightTheme, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    static func checkTheme(){
        guard let isLightTheme = IsLightTheme.isLightTheme else {
            Themer.shared.theme = .light
            return }
        Themer.shared.theme = isLightTheme == true ? .light : .dark
    }
}
