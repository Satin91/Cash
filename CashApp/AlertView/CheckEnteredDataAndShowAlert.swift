//
//  CheckEnteredDataAndShowAlert.swift
//  CashApp
//
//  Created by Артур on 7.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


class CheckEnteredDataAndShowAlert {
    
    var controller = UIViewController()
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
  
    func showAlertForScheduler(textFields: [UITextField],imageName: String, date: Date?) -> Bool {
        var message = ""
        for i in textFields {
            if i.text == "" {
                message = "Заполните все поля"
                controller.showMiniAlert(message: message, alertStyle: .warning)
                return false
            }
        }
        guard date != nil else {
            message = "Укажите дату"
            controller.showMiniAlert(message: message, alertStyle: .warning)
            return false
        }
        guard imageName != "emptyImage" else {
            message = "Выберите изображение"
            controller.showMiniAlert(message: message, alertStyle: .warning)
            return false
        }
        return false
    }
    func showAlertForCategories(textField: UITextField,imageName: String)-> Bool {
        
       print("CheckData")
        guard textField.text != "" else {
            controller.showMiniAlert(message: "Введите название категории", alertStyle: .warning)
           return false
        }
        guard imageName != "emptyImage" else {
            controller.showMiniAlert(message: "Выберите изображение" , alertStyle: .warning)
            return false
        }
        return true
    }
}
