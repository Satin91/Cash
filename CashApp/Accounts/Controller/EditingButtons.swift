//
//  EditingButtons.swift
//  CashApp
//
//  Created by Артур on 5.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

class EditingButtons: UIButton {
    
    let delete: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Delete", for: .normal)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 2
        button.layer.borderColor = ThemeManager.currentTheme().contrastColor2.cgColor
        button.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        button.setTitleColor(ThemeManager.currentTheme().subtitleTextColor, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0 // По умолчанию для включения анимации
        return button
    }()
    let save: UIButton = {
        let button = UIButton()
        button.setTitle("Сделать главным", for: .normal)
        button.layer.cornerRadius = 18
        button.backgroundColor = ThemeManager.currentTheme().titleTextColor
        button.setTitleColor(ThemeManager.currentTheme().backgroundColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
         button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0 // По умолчанию для включения анимации
         return button
    }()
    
    func showButtons(){
        
        UIView.animate(withDuration: 0.4, delay: 0.05) { [weak self] in
            self!.save.alpha = 1
            self!.delete.alpha = 1
        }

    }
    func hideButtons(){
        UIView.animate(withDuration: 0.4, delay: 0.05) { [weak self] in
            self!.save.alpha = 0
            self!.delete.alpha = 0
        }
    }
}
