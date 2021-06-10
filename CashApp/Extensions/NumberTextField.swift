//
//  NumberTextField.swift
//  CashApp
//
//  Created by Артур on 8.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class NumberTextField: UITextField,UITextFieldDelegate {

     var enteredSum = "0"

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        self.backgroundColor = .clear
        self.minimumFontSize = 17
        self.font = .systemFont(ofSize: 26)
        self.textAlignment = .center
        self.borderStyle = .roundedRect
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    

    var commaIsPressed = false
    @objc func textFieldChanged() {
        //print(self.text?.count)
        guard self.text?.isEmpty == false else {
            enteredSum = "0"; return}
        self.enteredSum = self.text!
        //Цикл для того, чтобы сделать одну запятую в тексте
        for i in enteredSum {
            if i == "." {
                commaIsPressed = true
                return
            }else {
                commaIsPressed = false
            }
        }
        //оператор для установки запятой автоматически после нуля
        if self.text?.count == 2, self.text?.first == "0" {
            
            self.text?.insert(".", at:   self.text!.index(  self.text!.startIndex, offsetBy: 1))
            commaIsPressed = true
            //self.enteredSum = popUpTextField.text!
            self.enteredSum = self.text! // дублируется присвоение для того чтобы установилась автоматическая плавающая точка
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let length = !string.isEmpty ? textField.text!.count + 1 : textField.text!.count - 1
     
        switch commaIsPressed {
        case true: // Запятая нажата
            allowedCharacters = CharacterSet(charactersIn: "0123456789")
        case false where length > 1: // запятая не нажата
            allowedCharacters = CharacterSet(charactersIn: ".0123456789")
        default:
            allowedCharacters = CharacterSet(charactersIn: "0123456789")
        }
        let characterSet = CharacterSet(charactersIn: string)
        //Ограничение по количеству символов
        if length > 9 {
            return false
        }
        return allowedCharacters.isSuperset(of: characterSet)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
