//
//  ThemeManager.swift
//  CashApp
//
//  Created by Артур on 12.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
   
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
     
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



class colors {
    
    //White colors
    var mainColor = "353B40"
    
    var backgroundColor = "F6F8F8"
    var secondaryBackgroundColor = "FFFFFF"
    var titleTextColor = "282D2F"
    var subtitleTextColor = "949798"
    var contrastColor1 = "507C59"
    var contrastColor2 = "A80019"
    var redColor = "81323D"
    var greenColor = "4E6C54"
    var yellowColor = "E8C511"
    
    var mainShadowColor = "A3B6C8"
    var buttonShadowColor = ""
    var separatorColor = "F3F3F6"
    var buttonBackgroundColorWhite = "353B40"
    var borderColor = "D0D9DE"
    //Dark colors
    var darkBackgroundColor = "1A1D1F"
    var darkSecondaryBackgroundColor = "252729"
    var darkTitleTextColor = "FAF8F2"
    var darkSubtitleTextColor = "797A7A"
    var darkContrastColor1 = "A28872"
    var darkContrastColor2 = "81323D"
    var darkMainShadowColor = "18191B"
    var darkButtonShadowColor = ""
    var darkSeparatorColor = "2F3232"
    var darkButtonBackgroundColorWhite = "353B40"
    var darkBorderColor = "34393D"
}
//bg 1A1D1F
//semi bg 252729
//title FAF8F2
//sub 797A7A
//separator 494845

enum Theme: Int {

    case white, dark

    var secondaryColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString("ffffff")
        case .dark:
            return UIColor().colorFromHexString("000000")
        }
    }
    
    
    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .white:
            return .default
        case .dark:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .white ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .white ? UIImage(named: "tabBarBackground") : nil
    }
//MARK: AlertColors
    var redColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().redColor)
        case .dark:
            return UIColor().colorFromHexString(colors().redColor)
        }
    }
    var greenColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().greenColor)
        case .dark:
            return UIColor().colorFromHexString(colors().greenColor)
        }
    }
    var yellowColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().yellowColor)
        case .dark:
            return UIColor().colorFromHexString(colors().yellowColor)
        }
    }
    
    //MARK: BackgroundColors
    var backgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().backgroundColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkBackgroundColor)
        }
    }
    var secondaryBackgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().secondaryBackgroundColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkSecondaryBackgroundColor)
        }
    }
    var borderColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().borderColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkBorderColor)
        }
    }
    var mainButtonBackgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().buttonBackgroundColorWhite)
        case .dark:
            return UIColor().colorFromHexString("353B40")
        }
    }
    var separatorColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().separatorColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkSeparatorColor)
        }
    }
    var shadowColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().mainShadowColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkMainShadowColor)
        }
        
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().titleTextColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkTitleTextColor)
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().subtitleTextColor)
        case .dark:
            return UIColor().colorFromHexString(colors().darkSubtitleTextColor)
        }
    }
    var contrastColor1: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().contrastColor1)
        case .dark :
            return UIColor().colorFromHexString(colors().darkContrastColor1)
        }
    }
    var contrastColor2: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().contrastColor2)
        case .dark :
            return UIColor().colorFromHexString(colors().darkContrastColor2)
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString("353B40")
        case .dark :
            return UIColor().colorFromHexString("F2F2F2")
        }
    }
    var mainShadow: UIColor {
        switch self {
        case .white:
            return UIColor().colorFromHexString(colors().mainShadowColor)
        case .dark :
            return UIColor().colorFromHexString("F2F2F2")
        }
    }
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.

class ThemeManager2 {

    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .dark
        }
    }
    
   
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()

        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.secondaryBackgroundColor
       
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = theme.contrastColor1

        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        UITabBar.appearance().backgroundColor = ThemeManager2.currentTheme().backgroundColor
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage

//        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
//        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
//        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator

        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)

        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)

        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)

        UISwitch.appearance().onTintColor = theme.secondaryBackgroundColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.secondaryBackgroundColor
        
    
               // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.

    }
}


