//
//  EditMonetaryCategory.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

extension AddOperationViewController {
    
    //Save
    func setDataForEditableControls() {
        self.nameTextField.text = newCategoryObject.name
        selectImageButton.setImage(UIImage(named: newCategoryObject.image), for: .normal)
        selectedImageName = newCategoryObject.image
        let imcomeOrExpenceText = newCategoryObject.stringEntityType == .expence ? "Изменить категорию расходов" : "Изменить категорию доходов"
        headingTextLabel.text = imcomeOrExpenceText
        descriptionLabel.text = "Внесите изменения в и сохраните результат"
        saveButtonOutlet.isEnabled = true
    }
    func saveElement(){
        try! realm.write({
            newCategoryObject.name = nameTextField.text!
            newCategoryObject.image = selectedImageName
            
            realm.add(newCategoryObject,update: .all)
        })
    }
    
    //Create
    func setDataForСreatingControls() {
        selectImageButton.setImage(UIImage(named: "AppIcon"), for: .normal)
        let imcomeOrExpenceText = newCategoryObject.stringEntityType == .expence ? "Создать категорию расходов" : "Создать категорию доходов"
        headingTextLabel.text = imcomeOrExpenceText
        descriptionLabel.text = "Назовите новую категорию и выбирете иконку"
        saveButtonOutlet.isEnabled = false
    }
    
    
    func createElement(){
        newCategoryObject.name = nameTextField.text!
        newCategoryObject.image = selectedImageName
        
        switch newCategoryObject.stringEntityType {
        case .expence:
            newCategoryObject.position = expenceObjects.count
        case .income:
            newCategoryObject.position = incomeObjects.count
        }
        guard let currency = mainCurrency?.ISO else {
            newCategoryObject.currencyISO = "USD"
            return}
        newCategoryObject.currencyISO = currency
        DBManager.addCategoryObject(object: newCategoryObject)
    }
 
}
