//
//  AccountCellAdvanced.swift
//  CashApp
//
//  Created by Артур on 17.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AccountCellAdvanced {
    
    
    weak var label: UILabel!
    init(label: UILabel) {
        self.label = label
    }
    
    func setIsMainAccount(account: MonetaryAccount) {
        
        switch account.isMainAccount {
        case true:
                self.label.alpha = 1
        case false:
                self.label.alpha = 0
        }
    }
    
    func enableUnderLine(textField: UITextField) {
        let attributedString = NSMutableAttributedString(string: textField.text!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        textField.attributedText = attributedString
    }
    
    func disableUnderLine(textField: UITextField){
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: textField.text!)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        textField.attributedText = attributeString
    }
}
