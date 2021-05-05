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

protocol CloseController{
    func reloadData()
}
class AddOperationViewController: UIViewController, UITextFieldDelegate, SendIconToParentViewController{
   
    func sendIconName(name: String) {
        selectedImageName = name
    }
    
    
  //Protocol for reload data to previous table view
    var tableReloadDelegate: CloseController!
    var ImageCollectionView: IconsCollectionView!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    func goToAddVC(restorationIdentifier: String) {
        
    }
   
    var newCategoryObject = MonetaryCategory()
    var changeValue = true
    let pointBetweenItems = 15
    ///                OUTLETS
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!

    
    
    //TextLabels
    @IBOutlet var headingTextLabel: UILabel!
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
    
    ///              STACK
    @IBOutlet var stackView: UIStackView!
    ///            ACTION BUTTONS
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
     //Выход описан в сториборде спомощью unwind
        
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
    
    
    func namesForLabels(){
        
        switch newCategoryObject.stringEntityType {
        case .income:
            headingTextLabel.text = "Add\nincome\ncategory"
        case .expence:
            headingTextLabel.text = "Add\nexpence\ncategory"
        }
    }
    
    ///                     View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        headingTextLabel.numberOfLines = 0
        limitSettings()
        namesForLabels()
        stackViewBasedCategory()
        stackViewSettings()
        selectImageButton.setImage(UIImage(named: "card"), for: .normal)
        selectImageButton.imageView?.contentMode = .scaleAspectFill
        selectImageButton.mainButtonTheme()
        
    
        
        setupNavigationController(Navigation: self.navigationController!)
        
        //Делегаты для collectionView назначены в сториборде
        visualSetup()
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
    func setupButtonsAndFields() {
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        //nameTextField.placeholder = "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        limitTextField.attributedPlaceholder = NSAttributedString(string: "Sum", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        
        nameTextField.delegate = self
        limitTextField.delegate = self
    }
    
    //              BLUR SIZE

    
    func visualSetup() {
        // labels
        
        //shadow
        nameTextField.textColor =      whiteThemeMainText
        limitTextField.backgroundColor = .none
        limitTextField.textColor =       whiteThemeMainText
        //line
        
        headingTextLabel.textColor = whiteThemeMainText
        ///Остальные настройки для TextField
        
        nameTextField.borderStyle = .roundedRect
        limitTextField.borderStyle = .roundedRect
        //Остальные view
        self.view.backgroundColor =  .white
        
        
    }
    
    func stackViewSettings() {
        if self.view.bounds.height < 600 {
            stackView.spacing = 15
        } else {
            stackView.spacing = 22
        }
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
        case false:
            newCategoryObject.name = nameTextField.text!
        }
        newCategoryObject.image = selectedImageName
        newCategoryObject.isEnabledLimit = limitSwitch.isOn
        DBManager.addCategoryObject(object: newCategoryObject)
    }
    
    
  
}
