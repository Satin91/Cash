//
//  EditMonetaryCategory.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit
import Themer

extension AddOperationViewController {
    
    //Save
    func setDataForEditableControls() {
        self.nameTextField.text = newCategoryObject.name
        selectedImageName = newCategoryObject.image
        let imcomeOrExpenceText = newCategoryObject.stringEntityType == .expence
        ? NSLocalizedString("category_edit_expence_heading_title", comment: "")
        : NSLocalizedString("category_edit_income_heading_title", comment: "")
        
        headingTextLabel.text = imcomeOrExpenceText
        //Скрывает описание
        descriptionLabel.isHidden = true
        descriptionLabel.text = "Внесите изменения в и сохраните результат"
        saveButtonOutlet.isEnabled = true
            
    }
    
    func saveElement() -> Bool {
        var isAvailibleToSave = false
        isAvailibleToSave = isEditingCategory ? saveEdit() : createElement()
        return isAvailibleToSave
    }
    
    func saveEdit()-> Bool{
        guard checkEnteredData() == true else {return false}
      
        try! realm.write({
            newCategoryObject.name = nameTextField.text!
            newCategoryObject.image = selectedImageName
            realm.add(newCategoryObject,update: .all)
        })

            return true
        }
    
    func checkEnteredData() -> Bool{
        return miniAlertView.showAlertForCategories(textField: nameTextField, imageName: selectedImageName)
    }
    
    //Create
    func setDataForСreatingControls() {
        let imcomeOrExpenceText = newCategoryObject.stringEntityType == .expence ? NSLocalizedString("category_expence_heading_title", comment: "") : NSLocalizedString("category_income_heading_title", comment: "")
        headingTextLabel.text = imcomeOrExpenceText
        descriptionLabel.text = NSLocalizedString("category_description_title", comment: "")
            
    }
    
    func sortedElements() {
            try! realm.write({
                for (index,expence) in expenceObjects.enumerated() {
                    expence.position = index
                    realm.add(expence,update: .all)
                }
            })
        
            try! realm.write({
                for (index,income) in incomeObjects.enumerated() {
                    income.position = index
                    realm.add(income,update: .all)
                }
            })
    }
    func createElement() -> Bool{
        
        guard checkEnteredData() else {return false}
        newCategoryObject.name = nameTextField.text!
        newCategoryObject.image = selectedImageName
        sortedElements()
        switch newCategoryObject.stringEntityType {
        case .expence:
            newCategoryObject.position = expenceObjects.count
        case .income:
            newCategoryObject.position = incomeObjects.count
        }
        guard let currency = mainCurrency?.ISO else {
            newCategoryObject.currencyISO = "USD"
            return false}
        newCategoryObject.currencyISO = currency
        DBManager.addCategoryObject(object: newCategoryObject)
        return true
    }
 
}
