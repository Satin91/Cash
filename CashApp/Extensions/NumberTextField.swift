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
    var button = UIButton(type: .custom)
    
    func createRightButton(text: String) {
        button.setImage(UIImage(named: "send.png"), for: .normal)
        button.setTitle(text, for: .normal)
        button.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        button.setTitleColor(ThemeManager.currentTheme().borderColor, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -17, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
          
            button.frame = CGRect(x: CGFloat(super.frame.size.width - 40), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        self.rightView = button
        self.rightViewMode = .always
            
            
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
    var availableDirection = false
    var minusIsPressed = false
  
    
    func removeUnnecessary(inputString: String) ->String {
       // var strOne = inputString
        var strTwo = inputString.replacingOccurrences(of: " ", with: "")
        strTwo = strTwo.replacingOccurrences(of: ",", with: ".")
        if strTwo.last == "."{
            
            strTwo.removeLast()
        }
        if strTwo.count == 1 && strTwo == "-" {
            return "0"
        }
       return strTwo
    }
    
    func checkMinus(string: String) -> Bool {
        var minus = false
        for i in string {
            if i == "-" {
                minus = true

            }
        }
        return minus
    }
    
    func checkComma(string: String) -> Bool {
        var comma = false
        for i in string {
            if i == "," {
                comma = true
            }
        }
        return comma
    }
    
    
    @objc func textFieldChanged() {
        guard self.text?.isEmpty == false else {
            enteredSum = "0"; return}
        
       
        if self.text!.last == "," {
            let newtext = self.text?.replacingOccurrences(of: ",", with: ".")
            self.text = newtext
        }
        
    
        //Автоматическая вставка запятой между двумя первыми знаками (если первым не стоит минус)
        if self.text!.count == 2, self.text!.first == "0" && minusIsPressed == false && commaIsPressed == false {
            self.text!.insert(".", at:   self.text!.index(  self.text!.startIndex, offsetBy: 1))
            self.text = self.text!.replacingOccurrences(of: ".", with: ",")
            
            
            commaIsPressed = true
            
        }else if self.text!.count == 3, self.text![1] == "0" && minusIsPressed == true && commaIsPressed == false {
            self.text!.insert(".", at:   self.text!.index(  self.text!.startIndex, offsetBy: 2))
            self.text = self.text!.replacingOccurrences(of: ".", with: ",")
            commaIsPressed = true
        }
        
        var decimalNumber  = removeUnnecessary(inputString: self.text!)
        
        //замена точки на запятую, если точка в ручную введена
        if self.text!.last == "," || self.text!.last == "."{
           
            self.text = self.text?.replacingOccurrences(of: ".", with: ",")
            
            decimalNumber = removeUnnecessary(inputString: self.text!)
            
        } else if self.text!.last == "-"{
            self.text = text
            decimalNumber = removeUnnecessary(inputString: self.text!)
        }
        
        commaIsPressed = checkComma(string: self.text!)
        minusIsPressed = checkMinus(string: self.text!)
        if commaIsPressed == false && decimalNumber != "0" {
            //Почему то другими сппособами не получается
           
           // decimalNumber = self.text!
            self.text = Metric(value: Double(decimalNumber)!).formattedValue
           
            
        }else{
            
            self.text = self.text
        }
        

        //установка значения запятой
        
        enteredSum = decimalNumber
        
        }
            
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let length = !string.isEmpty ? textField.text!.count + 1 : textField.text!.count - 1
        
        
        if availableDirection == true {
            
             allowedCharacters = CharacterSet(charactersIn: "0123456789")
            if commaIsPressed == false && (string == "." || string == ",") && length > 1 {
                allowedCharacters = CharacterSet(charactersIn: ".,0123456789")
                commaIsPressed = true
            }
        }else{
            if length == 1 {
                allowedCharacters = CharacterSet(charactersIn: "-0123456789")
                if string == "-" {
                    minusIsPressed = true
                }
            }else if commaIsPressed == false && minusIsPressed == false && length > 1{
                allowedCharacters = CharacterSet(charactersIn: ".,0123456789")
                if string == "." || string == "," {
                    
                    commaIsPressed = true
                }
            }else if minusIsPressed == true && commaIsPressed == false && length > 2 {
                allowedCharacters = CharacterSet(charactersIn: ".,0123456789")
                if string == "." || string == ","{
                    commaIsPressed = true
                }
            }
//
//
//            if commaIsPressed == true {
//                allowedCharacters = CharacterSet(charactersIn: "0123456789")
//
//            }else if commaIsPressed == false && length > 2{
//                allowedCharacters = CharacterSet(charactersIn: ".0123456789")
//            }
        }
        
        
        

        
        
        var str = string
        if string == "," {
            str = "."
        }
        let characterSet = CharacterSet(charactersIn: str)
        //Ограничение по количеству символов
        if length > 15 {
            return false
        }
        return allowedCharacters.isSuperset(of: characterSet)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

