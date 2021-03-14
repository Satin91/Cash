//
//  BorderButtomView.swift
//  CashApp
//
//  Created by Артур on 17.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import Foundation
import UIKit

class BorderButtonView: UIView {
 
    //drop shadow
    let dropView: UIView = {
        let view = UIView()
        //view.backgroundColor = .none
        view.layer.borderWidth = 2.5
        view.layer.borderColor = whiteThemeBackground.cgColor
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        
        return view
    }()
    //inner shadow
    let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderWidth = 2.5
        view.layer.borderColor = whiteThemeBackground.cgColor
        view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        
        return view
    }()
    
let textField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSettings()
        //setShadow(view: dropView)
        //setShadow(view: innerView)
        shadowForView()
        // Не понимаю почему, но вью так и не смоглотрансоллизоваться
  
        self.backgroundColor = .clear
    }

    let shadow = CALayer()
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
    
// shadow with CALayer dont works in freeFormView

    func shadowForView() {
        dropView.setShadow(view: dropView, size: CGSize(width: 1, height: 1), opacity: 1, radius: 1, color: #colorLiteral(red: 0.7137254902, green: 0.7647058824, blue: 0.8, alpha: 1))
        innerView.setShadow(view: innerView, size: CGSize(width: -1, height: -1), opacity: 1, radius: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    func viewSettings() {
        self.layer.masksToBounds = false
        self.backgroundColor = .none
        innerView.frame = self.bounds
        innerView.layer.cornerRadius = innerView.bounds.height / 2
        innerView.backgroundColor = .none
        dropView.frame = self.bounds
        dropView.layer.cornerRadius = dropView.bounds.height / 2
        dropView.backgroundColor = .none
        self.insertSubview(dropView, at: 0)
        self.insertSubview(innerView, at: 1)
        super.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        innerView.translatesAutoresizingMaskIntoConstraints = false
        dropView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
      
        self.backgroundColor = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //viewSettings()
    }
}
