//
//  NeoView.swift
//  CashApp
//
//  Created by Артур on 13.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

class NeoView: UIView {
 
 
    //drop shadow
    let darkShadow: UIView = {
        let view = UIView()
        view.backgroundColor = whiteThemeBackground
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        return view
    }()
    //inner shadow
 
    let whiteShadow: UIView = {
        let view = UIView()
        view.backgroundColor = whiteThemeBackground
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        return view
    }()
    
let textField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSettings()
        shadowForView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSettings()
        shadowForView()
        self.backgroundColor = .clear
    }

    func shadowForView() {
        darkShadow.setShadow(view: darkShadow, size: CGSize(width: 6, height: 6), opacity: 0.4, radius: 5, color: #colorLiteral(red: 0.5019607843, green: 0.5960784314, blue: 0.6666666667, alpha: 1))
        whiteShadow.setShadow(view: whiteShadow, size: CGSize(width: -6, height: -6), opacity: 1, radius: 5, color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
    }
    
    func viewSettings() {
        self.backgroundColor = .black
        
        // whiteShadow.backgroundColor = .none
        whiteShadow.frame = self.bounds
        whiteShadow.layer.cornerRadius = 18
        
        // darkShadow.backgroundColor = .none
        darkShadow.frame = self.bounds
        darkShadow.layer.cornerRadius = 18
        
        
        self.insertSubview(darkShadow, at: 0)
        self.insertSubview(whiteShadow, at: 1)
     
     //   self.translatesAutoresizingMaskIntoConstraints = false
      
        self.backgroundColor = .none
    }

}
