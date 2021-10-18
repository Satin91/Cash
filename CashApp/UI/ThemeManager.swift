//
//  ThemeManager.swift
//  CashApp
//
//  Created by Артур on 10.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer


struct MyThemeSettings: ThemeModelProtocol {

    var backgroundColor: UIColor
    var secondaryBackgroundColor: UIColor
    var titleTextColor: UIColor
    var subtitleTextColor: UIColor
    var contrastColor1: UIColor
    var contrastColor2: UIColor
    var redColor: UIColor
    var greenColor: UIColor
    var yellowColor: UIColor
    var borderColor:UIColor
    var separatorColor:UIColor
    var shadowColor:UIColor
    var blackColor:UIColor
}

extension MyThemeSettings {
    static let lightTheme = MyThemeSettings(
        backgroundColor:  UIColor().colorFromHexString(colors().backgroundColor),
        secondaryBackgroundColor:UIColor().colorFromHexString(colors().secondaryBackgroundColor),
        titleTextColor:UIColor().colorFromHexString(colors().titleTextColor),
        subtitleTextColor:UIColor().colorFromHexString(colors().subtitleTextColor),
        contrastColor1:  UIColor().colorFromHexString(colors().contrastColor1),
        contrastColor2:UIColor().colorFromHexString(colors().contrastColor2),
        redColor: UIColor().colorFromHexString(colors().redColor),
        greenColor: UIColor().colorFromHexString(colors().greenColor),
        yellowColor: UIColor().colorFromHexString(colors().yellowColor),
        borderColor: UIColor().colorFromHexString(colors().borderColor),
        separatorColor: UIColor().colorFromHexString(colors().separatorColor),
        shadowColor: UIColor().colorFromHexString(colors().mainShadowColor),
        blackColor: UIColor().colorFromHexString(colors().blackColor)
    )
        
    static let darkTheme = MyThemeSettings(
        backgroundColor: UIColor().colorFromHexString(colors().darkBackgroundColor),
        secondaryBackgroundColor: UIColor().colorFromHexString(colors().darkSecondaryBackgroundColor),
        titleTextColor: UIColor().colorFromHexString(colors().darkTitleTextColor),
        subtitleTextColor: UIColor().colorFromHexString(colors().darkSubtitleTextColor),
        contrastColor1: UIColor().colorFromHexString(colors().darkContrastColor1),
        contrastColor2: UIColor().colorFromHexString(colors().darkContrastColor2),
        redColor: UIColor().colorFromHexString(colors().redColor),
        greenColor: UIColor().colorFromHexString(colors().greenColor),
        yellowColor: UIColor().colorFromHexString(colors().yellowColor),
        borderColor: UIColor().colorFromHexString(colors().darkBorderColor),
        separatorColor: UIColor().colorFromHexString(colors().darkSeparatorColor),
        shadowColor: UIColor().colorFromHexString(colors().darkMainShadowColor),
        blackColor: UIColor().colorFromHexString(colors().blackColor)
    )
}




enum MyTheme: ThemeProtocol {
    case light
    case dark
    var settings: MyThemeSettings {
        switch self {
        case .light: return MyThemeSettings.lightTheme
        case .dark: return MyThemeSettings.darkTheme
        }
    }
}
extension Themer where Theme == MyTheme {
    private static var instance: Themer?
    static var shared: Themer {
        if instance == nil {
            instance = Themer(defaultTheme: .light)
        }
        return instance!
    }
}

