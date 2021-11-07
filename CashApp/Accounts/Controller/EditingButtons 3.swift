//
//  EditingButtons.swift
//  CashApp
//
//  Created by Артур on 5.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
import Themer
class EditingButtons{
    
    let colors = AppColors()
    let cornerRadius: CGFloat = 12
    func setColors() {
        colors.loadColors()
        delete.backgroundColor = .clear
        delete.layer.borderColor = colors.contrastColor2.cgColor
        delete.setTitleColor(colors.titleTextColor, for: .normal)
        delete.setTitleColor(colors.subtitleTextColor, for: .disabled)
        delete.setTitleColor(colors.titleTextColor, for: .normal)
        delete.layer.cornerRadius = self.cornerRadius
        
        save.layer.cornerRadius = self.cornerRadius
        save.backgroundColor = colors.contrastColor1
        save.setTitleColor(colors.titleTextColor, for: .normal)
        
    }
    
 
    let delete: UIButton = {
        
       let button = UIButton()
        
        button.setTitle("Delete", for: .normal)
        button.layer.borderWidth = 2
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0 // По умолчанию для включения анимации
        return button
    }()
    let save: UIButton = {
        let button = UIButton()
        button.setTitle("Сделать главным", for: .normal)
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
