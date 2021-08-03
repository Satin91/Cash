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
    
    func goToAddVC(restorationIdentifier: String) {
        
    }
    
    var newCategoryObject = MonetaryCategory()
    var changeValue = true
    
    lazy var isEditingCategory = false
    var vector: Bool = false
    let pointBetweenItems = 15
    ///                OUTLETS
    @IBOutlet var expenceVectorButtonOutlet: UIButton!
    @IBOutlet var incomeVectorButtonOutlet: UIButton!
    
    
    
    @IBAction func expenceVectorAction(_ sender: UIButton) {
        self.vector = false
        expenceVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) {
            self.incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
            self.expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
        }
        
    }
    
    @IBAction func incomeVectorAction(_ sender: UIButton) {
        self.vector = true
        incomeVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) {
            self.expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
            self.incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
        }
    }
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!
    //TextLabels
    @IBOutlet var headingTextLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var limitLabel: UILabel!
    //switch
    @IBAction func isEnabledLimit(_ sender: Any) {
        if limitSwitch.isOn {
            limitTextField.isHidden = false
        }else{
            limitTextField.isHidden = true
        }
        
    }
    @IBOutlet var limitSwitch: UISwitch!
    ///                TEXT FIELDS
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var limitTextField: UITextField!
    
    ///            ACTION BUTTONS
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        //Выход описан в сториборде спомощью unwind
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneAction(_ sender: Any) {
        saveElement()
        tableReloadDelegate.reloadData()
        dismiss(animated: true, completion: nil) // Если модальное окно
        _ = navigationController?.popViewController(animated: true) //Exit если нет
        
    }
    @IBOutlet var selectImageButton: UIButton!
    var selectedImageName = "card" {
        willSet{
            selectImageButton.setImage(UIImage(named: newValue), for: .normal)
        }
    }
    var iconsCollectionView: IconsCollectionView!
    @IBAction func selectImageButtonAction(_ sender: Any) {
        iconsCollectionView = IconsCollectionView(frame: self.view.bounds)
        iconsCollectionView.sendImageDelegate = self
        self.view.addSubview(iconsCollectionView)
        view.animateViewWithBlur(animatedView: iconsCollectionView, parentView: self.view)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    
    deinit {
    }
    
    func setupButtonsAndFields() {
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        //nameTextField.placeholder = "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().subtitleTextColor ])
        limitTextField.attributedPlaceholder = NSAttributedString(string: "Limit", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().subtitleTextColor ])
        nameTextField.changeVisualDesigh()
        limitTextField.changeVisualDesigh()
        
        
        nameTextField.delegate = self
        limitTextField.delegate = self
    }
    func namesForLabels(){
        
        switch isEditingCategory {
        case true:
            headingTextLabel.text = "Добавить новую категорию"
            descriptionLabel.text = "Заполните данные и выберите направление категории"
        case false:
            headingTextLabel.text = "Изменить категорию"
            descriptionLabel.text = "Заполните данные и выберите направление категории"
        }
    }
    
  
    func visualSettings() {
        namesForLabels()
        setupButtonsAndFields()
        selectImageButton.setImage(UIImage(named: "AppIcon"), for: .normal)
        selectImageButton.imageView?.contentMode = .scaleAspectFill
        
        headingTextLabel.numberOfLines = 0
        isModalInPresentation = true
        
        selectImageButton.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        selectImageButton.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        selectImageButton.layer.cornerRadius = 25
        
        descriptionLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .light)
        
        incomeVectorButtonOutlet.setTitleColor(ThemeManager.currentTheme().borderColor, for: .normal)
        expenceVectorButtonOutlet.setTitleColor(ThemeManager.currentTheme().borderColor, for: .normal)
        incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
        expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
        incomeVectorButtonOutlet.layer.cornerRadius = 10
        expenceVectorButtonOutlet.layer.cornerRadius = 10
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
    ///                     View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        limitSettings()
        stackViewBasedCategory()
        visualSettings()
        
        
        
        
        setupNavigationController(Navigation: self.navigationController!)
        
        //Делегаты для collectionView назначены в сториборде
        doneButton.isEnabled = false
        setupButtonsAndFields()
    }
    
    
    ///               invome/expence
    func stackViewBasedCategory(){
        switch newCategoryObject.stringEntityType {
        case .expence:
            //sum
            limitTextField.isHidden = true
        case .income :
            limitTextField.isHidden = true
            //secondSum
            limitSwitch.isHidden = true
            limitLabel.isHidden = true
        }
        
    }
    func limitSettings() {
        limitSwitch.isOn = false
        limitTextField.isHidden = true
        
    }
    ///                     TEXT FIELD FUNC
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        limitTextField.resignFirstResponder()
        return false
    }
   
    ///Проверка на пустую строку
    @objc private func textFieldChanged() {
        if nameTextField.text?.isEmpty == false {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    // Сохраняет элементы в базу
    func saveElement(){
        switch limitSwitch.isOn {
        case true:
            newCategoryObject.name = nameTextField.text!
            newCategoryObject.limit = Double(limitTextField.text!)!
            newCategoryObject.position = expenceObjects.count
            
        case false:
            newCategoryObject.name = nameTextField.text!
            newCategoryObject.position = incomeObjects.count
        }
        newCategoryObject.image = selectedImageName
        newCategoryObject.isEnabledLimit = limitSwitch.isOn
        
        newCategoryObject.position = vector ? incomeObjects.count : expenceObjects.count
        newCategoryObject.stringEntityType = vector ? .expence : .income
        DBManager.addCategoryObject(object: newCategoryObject)
    }
    
    
    
}
