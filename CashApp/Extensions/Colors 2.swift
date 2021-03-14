//
//  File.swift
//  CashApp
//
//  Created by Артур on 10/17/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import Foundation
import UIKit

struct whiteTheme {
let whiteThemeBackground = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 1)
let whiteThemeMainText: UIColor
let whiteThemetranslucentText: UIColor
    
}

let whiteThemeBackground: UIColor = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9607843137, alpha: 1)
let whiteThemeMainText: UIColor = #colorLiteral(red: 0.2274509804, green: 0.2745098039, blue: 0.3411764706, alpha: 1)
let whiteThemeTranslucentText: UIColor = #colorLiteral(red: 0.6823529412, green: 0.7333333333, blue: 0.768627451, alpha: 1)
let whiteThemeRed: UIColor = #colorLiteral(red: 0.9411764706, green: 0.1725490196, blue: 0.3960784314, alpha: 1)
let whiteThemeShadowText: UIColor = #colorLiteral(red: 0.1098039216, green: 0.1843137255, blue: 0.2745098039, alpha: 1)
let whiteThemeFirstGradientColor: UIColor = #colorLiteral(red: 0.3568627451, green: 0.9294117647, blue: 0.9529411765, alpha: 1)
let whiteThemeSecondGradientColor: UIColor = #colorLiteral(red: 0.337254902, green: 0.7215686275, blue: 0.9882352941, alpha: 1)
let whiteThemeGreen: UIColor = #colorLiteral(red: 0.1137254902, green: 0.8156862745, blue: 0.6549019608, alpha: 1)


func setColorsForText(text: [UILabel]) {
    let labelColor = whiteThemeMainText
    
    for (_, color) in text.enumerated() {
        color.textColor = labelColor
    }
    
}


