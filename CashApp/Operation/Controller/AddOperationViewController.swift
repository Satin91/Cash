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

protocol ReloadTableView{
    func reloadTableView()
}
class AddOperationViewController: UIViewController, UITextFieldDelegate{
    
  
    var tableReloadDelegate: ReloadTableView!
    
    @IBOutlet var doneButton: UIBarButtonItem!
    
    func goToAddVC(restorationIdentifier: String) {
        
    }
    var selectedImageName: String?
    var newCategoryObject = MonetaryCategory()
    var changeValue = true
    let pointBetweenItems = 15
    ///                OUTLETS
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    //TextLabels
    @IBOutlet var upperTextLabel: UILabel!
    @IBOutlet var middleTextLabel: UILabel!
    @IBOutlet var bottomTextLabel: UILabel!
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
        tableReloadDelegate.reloadTableView()
        dismiss(animated: true, completion: nil) // Если модальное окно
        _ = navigationController?.popViewController(animated: true) //Exit если нет
        
    }
    @IBOutlet var selectImageButton: UIButton!
    @IBAction func selectImageAction(_ sender: Any) {
        view.animateView(animatedView: blurView, parentView: self.view)
        view.animateView(animatedView: popUpView, parentView: self.view)
        view.endEditing(true) // Это для того случая, если пользователь выберет "Добавить иконку" до того, как скроется клавиатура
    }
    @IBAction func cancelGestureTipe(_ sender: Any) {
        view.reservedAnimateView(animatedView: blurView, viewController: nil)
        view.reservedAnimateView(animatedView: popUpView, viewController: nil)
    }
    
    ///            IMAGES ARRAY
    let imagesForCollection = ["alcohol", "appliances", "bank", "bankCard", "books", "bowling", "cancel", "car", "carRepair", "carwash", "casino", "cellphone", "charity", "cigarettes", "cinema", "cleaning", "clothes", "construction", "cosmetics", "delivery", "dentist", "drugs", "education", "electricity", "error", "fitness", "flights", "flowers", "food", "fuel", "furniture", "games", "gas", "gifts", "glasses", "goverment", "hello", "hotel", "housing", "identification", "insurancy", "internet", "kids", "laundry", "lock", "luxuries", "magazine", "media", "medicine", "musicalInstruments", "other", "parking", "pets", "pool", "publicTransport", "purchases", "refill", "request", "send", "shoeRepair", "sport", "stadium", "stationery", "taxes", "taxi", "telephone", "tollRoad", "tourism", "toys", "trafficFine", "train", "tv", "unlock", "waterRransport", "withdraw"]
    

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
        upperTextLabel.text = "Add"
        bottomTextLabel.text = "category"
        switch newCategoryObject.stringEntityType {
        case .income:
            middleTextLabel.text = "income"
        case .expence:
            middleTextLabel.text = "expence"
        }
    }
    
    ///                     View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        limitSettings()
        namesForLabels()
        viewSelection()
        stackViewSettings()
        selectImageButton.setImage(UIImage(named: "card"), for: .normal)
        selectImageButton.imageView?.contentMode = .scaleAspectFill
        selectImageButton.mainButtonTheme()
        
        ///////
//        segmentedControl.changeValuesForCashApp(segmentOne: "To you", segmentTwo: "From you")
        ////
        
        setupNavigationController(Navigation: self.navigationController!)
        collectionView.clipsToBounds = true
        //Делегаты для collectionView назначены в сториборде
        popUpAndBlurSize()
        whiteThemeColors()
        doneButton.isEnabled = false
        setupButtonsAndFields()
    }
    
    
    ///               view selection func
    func viewSelection(){
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
    func popUpAndBlurSize() {
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.7, height: self.view.bounds.height*0.6)
        popUpView.layer.cornerRadius = 18
        blurView.bounds = self.view.bounds
        
    }
    
    func whiteThemeColors() {
        // labels
        
        //shadow
        nameTextField.textColor =      whiteThemeMainText
        limitTextField.backgroundColor = .none
        limitTextField.textColor =       whiteThemeMainText
        //text
        middleTextLabel.textColor =    whiteThemeRed
        //collectionView
        collectionView.layer.backgroundColor = .none
        //line
        popUpView.backgroundColor = .white
        upperTextLabel.textColor = whiteThemeMainText
        middleTextLabel.textColor = whiteThemeRed
        bottomTextLabel.textColor = whiteThemeMainText
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
        
        newCategoryObject.isEnabledLimit = limitSwitch.isOn
        DBManager.addCategoryObject(object: newCategoryObject)
    }
    
    
  
}


///                           COLLECTION VIEW
extension AddOperationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    //                  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 4
        let paddingWidth = 10 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 17
    }
    
    //    @available(iOS 6.0, *)
    //    optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    
    //                UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imagesForCollection[indexPath.row]
        let selectedImage = UIImage(named: image)
        selectedImageName = image
        selectImageButton.setImage(selectedImage, for: .normal)
        
        view.reservedAnimateView(animatedView: popUpView, viewController: nil)
        view.reservedAnimateView(animatedView: blurView, viewController: nil)
        
        
    }
    //                 UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesForCollection.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell
        let images = imagesForCollection[indexPath.item]
        let image = imageToData(imageName: images)// Перевод в Data нужен лишь для того чтобы потом можно было с легкостью сохранить изображение в базу данных, открыть в ячейке можно и не png файл
        cell.imageView.image = UIImage(data: image)
        cell.imageView.setImageColor(color: whiteThemeMainText)
        
        return cell
    }
    
}

