//
//  Themes.swift
//  CashApp
//
//  Created by Артур on 9.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

struct MyThemeSettings {

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
        shadowColor: UIColor().colorFromHexString(colors().mainShadowColor))
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
        shadowColor: UIColor().colorFromHexString(colors().darkMainShadowColor)
    )
}
@objc enum MyTheme: Int {
    case light
    case dark
    var settings: MyThemeSettings{
        switch self {
        case .light:
            return MyThemeSettings.lightTheme
        case .dark:
            return MyThemeSettings.darkTheme
      
        }
    }
}
@objc protocol Themable {
    func applyTheme(_ theme: MyTheme)
}
final class ThemManager {
    private var themables = NSHashTable<Themable>
        .weakObjects()
    
    var theme: MyTheme {
        didSet {
            guard theme != oldValue else { return}
            apply()
        }
    }
    private init(defaultTheme: MyTheme) {
        self.theme = defaultTheme
    }
    
    private static var instance: ThemManager?
    
    static var shared: ThemManager {
        if instance == nil  {
            instance = ThemManager(defaultTheme: .light)
        }
        return instance!
    }
    func register(_ themable: Themable ) {
        themables.add(themable)
        themable.applyTheme(theme)
    }
    
    private func apply() {
        themables.allObjects.forEach{
            $0.applyTheme(theme)
        }
    }
}
class HighlightedLabel: UILabel, Themable {
   
    func applyTheme(_ theme: MyTheme) {
        textColor = theme.settings.titleTextColor
        backgroundColor = theme.settings.subtitleTextColor
        switch theme {
        case .light:
        text = "Light"
        case .dark:
        text = "Dark"
        }
        sizeToFit()
    }
    
    
    override func didMoveToWindow() {
        ThemManager.shared.register(self)
        super.didMoveToWindow()
    }
}



//
//protocol ThemeProtocol {
//    var backgroundColor: UIColor {get}
//    var secondaryBackgroundColor: UIColor {get}
//    var titleTextColor: UIColor {get}
//    var subtitleTextColor: UIColor {get}
//    var contrastColor1: UIColor {get}
//    var contrastColor2: UIColor {get}
//
//    var redColor: UIColor {get}
//    var greenColor: UIColor {get}
//    var yellowColor: UIColor {get}
//
//    var borderColor:UIColor {get}
//    var separatorColor:UIColor {get}
//    var shadowColor:UIColor {get}
//
//}
//class ThemeManager2 {
//    static var theme: ThemeProtocol = LightTheme() {
//        willSet {
//            _ = currentTheme()
//        }
//    }
//    static func currentTheme() -> ThemeProtocol{
//
//        return theme
//    }
//    //static var currentTheme: ThemeProtocol = LightTheme()
//}
//
//class LightTheme: ThemeProtocol {
//    var backgroundColor: UIColor = UIColor().colorFromHexString(colors().backgroundColor)
//
//    var secondaryBackgroundColor: UIColor = UIColor().colorFromHexString(colors().secondaryBackgroundColor)
//
//    var titleTextColor: UIColor = UIColor().colorFromHexString(colors().titleTextColor)
//
//    var subtitleTextColor: UIColor = UIColor().colorFromHexString(colors().subtitleTextColor)
//
//    var contrastColor1: UIColor = UIColor().colorFromHexString(colors().contrastColor1)
//
//    var contrastColor2: UIColor = UIColor().colorFromHexString(colors().contrastColor2)
//
//    var redColor: UIColor = UIColor().colorFromHexString(colors().redColor)
//
//    var greenColor: UIColor = UIColor().colorFromHexString(colors().greenColor)
//
//    var yellowColor: UIColor = UIColor().colorFromHexString(colors().yellowColor)
//
//    var borderColor: UIColor = UIColor().colorFromHexString(colors().borderColor)
//
//    var separatorColor: UIColor = UIColor().colorFromHexString(colors().separatorColor)
//
//    var shadowColor: UIColor = UIColor().colorFromHexString(colors().mainShadowColor)
//
//}
//
//class DarkTheme: ThemeProtocol {
//    var backgroundColor: UIColor = UIColor().colorFromHexString(colors().darkBackgroundColor)
//
//    var secondaryBackgroundColor: UIColor = UIColor().colorFromHexString(colors().darkSecondaryBackgroundColor)
//
//    var titleTextColor: UIColor = UIColor().colorFromHexString(colors().darkTitleTextColor)
//
//    var subtitleTextColor: UIColor = UIColor().colorFromHexString(colors().darkSubtitleTextColor)
//
//    var contrastColor1: UIColor = UIColor().colorFromHexString(colors().darkContrastColor1)
//
//    var contrastColor2: UIColor = UIColor().colorFromHexString(colors().darkContrastColor2)
//
//    var redColor: UIColor = UIColor().colorFromHexString(colors().redColor)
//
//    var greenColor: UIColor = UIColor().colorFromHexString(colors().greenColor)
//
//    var yellowColor: UIColor = UIColor().colorFromHexString(colors().yellowColor)
//
//    var borderColor: UIColor = UIColor().colorFromHexString(colors().darkBorderColor)
//
//
//    var separatorColor: UIColor = UIColor().colorFromHexString(colors().darkSeparatorColor)
//
//    var shadowColor: UIColor = UIColor().colorFromHexString(colors().darkMainShadowColor)
//
//
//
//}
