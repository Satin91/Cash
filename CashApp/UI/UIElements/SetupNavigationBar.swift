//
//  SetupNavigationBar.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

class setupNavigationBar {
    let colors = AppColors()
    func theme(_ theme: MyTheme) {
        UINavigationBar.appearance().barTintColor = theme.settings.subtitleTextColor
        UINavigationBar.appearance().tintColor = theme.settings.contrastColor1
        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 26)!]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.settings.contrastColor1]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().prefersLargeTitles = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 26 - 12
        paragraphStyle.alignment = .left
        UINavigationBar.appearance().largeTitleTextAttributes  = [.font: UIFont.systemFont(ofSize: 46, weight: .medium), .paragraphStyle: paragraphStyle, .foregroundColor: theme.settings.titleTextColor  ]
     
    }
    
    func setColors() {
        Themer.shared.register(target: self, action: setupNavigationBar.theme(_:))
//        colors.loadColors()
//        UINavigationBar.appearance().barTintColor = colors.subtitleTextColor
//        UINavigationBar.appearance().tintColor = colors.contrastColor1
//
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : colors.contrastColor1]
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().prefersLargeTitles = false
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.firstLineHeadIndent = 26 - 12
//        paragraphStyle.alignment = .left
//        UINavigationBar.appearance().largeTitleTextAttributes  = [.font: UIFont.systemFont(ofSize: 46, weight: .medium), .paragraphStyle: paragraphStyle, .foregroundColor: colors.titleTextColor  ]
//        let contr = UINavigationController()
        
    }
    
}
