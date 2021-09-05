//
//  AddExpenseViewController.swift
//  CashApp
//
//  Created by Артур on 10/17/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift


class AddOperationViewController: UIViewController, UITextFieldDelegate, SendIconToParentViewController{
    
    func sendIconName(name: String) {
        selectedImageName = name
    }
    
    
    //Protocol for reload data to previous table view
    var tableReloadDelegate: ReloadParentTableView!
    var ImageCollectionView: IconsCollectionView!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    var newCategoryObject = MonetaryCategory()
    var changeValue = true
    
    lazy var isEditingCategory = false
    var vector: Bool = false
    let pointBetweenItems = 15
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!
    //TextLabels
    @IBOutlet var headingTextLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    ///                TEXT FIELDS
    @IBOutlet var nameTextField: UITextField!
    
    ///            ACTION BUTTONS
    @IBOutlet var saveButtonOutlet: UIButton!
    @IBAction func saveButtonAction(_ sender: Any) {
        isEditingCategory == true ? saveElement() : createElement()
        tableReloadDelegate.reloadData()
        dismiss(animated: true, completion: nil) // Если модальное окно
        _ = navigationController?.popViewController(animated: true) //Exit если нет
        
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        //Выход описан в сториборде спомощью unwind
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneAction(_ sender: Any) {
        
    }
    @IBOutlet var selectImageButton: UIButton!
    var selectedImageName = "card" {
        willSet{
            selectImageButton.setImage(UIImage(named: newValue), for: .normal)
        }
    }
    var iconsCollectionView = IconsCollectionView()
    @IBAction func selectImageButtonAction(_ sender: Any) {
        present(iconsCollectionView, animated: true) {
            self.iconsCollectionView.sendImageDelegate = self
        }
    }
    ///                     View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        visualSettings()
        iconsCollectionView.sendImageDelegate = self
        setupControls()
        print(isEditingCategory)
    }
    
    
    func setupControls() {
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().subtitleTextColor ])
        nameTextField.changeVisualDesigh()
        nameTextField.delegate = self
    }
   
    func visualSettings() {
        headingTextLabel.numberOfLines = 0
        selectImageButton.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        selectImageButton.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        selectImageButton.layer.cornerRadius = 25
        let saveButtomTitle = isEditingCategory ? "Save" : "Create"
        saveButtonOutlet.mainButtonTheme(color: ThemeManager.currentTheme().contrastColor1, saveButtomTitle)
        descriptionLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .light)
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        isEditingCategory == true ? setDataForEditableControls() : setDataForСreatingControls()
        self.isModalInPresentation = false
    }
    


    ///                     TEXT FIELD FUNC
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }
    
    ///Проверка на пустую строку
    @objc private func textFieldChanged() {
        if nameTextField.text?.isEmpty == false {
            saveButtonOutlet.isEnabled = true
        } else {
            saveButtonOutlet.isEnabled = false
        }
    }
    

}
