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
class AddSpendingViewController: UIViewController, UITextFieldDelegate{
    
    
    
    
    
    
    
    
    @IBOutlet var selectDateView: NeomorphicView!
    
    
    var newEntityElement = MonetaryEntity()
    var changeValue = true
    let pointBetweenItems = 15
    var middleText = "" // Переменная для принятия текста из других классов
    var bottomText = "" // Переменная для принятия текста из других классов
    
    ///                OUTLETS
    @IBOutlet var okOutlet: UIButton!
    //exit в сториборде
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var addCategory: [UILabel]!
    @IBOutlet var middleTextLabel: UILabel!
    @IBOutlet var selectDateLabel: UILabel!
    @IBOutlet var okNeomorph: NeomorphicView!
    
    ///                TEXT FIELDS
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var sumTextField: UITextField!
    
    ///              STACK
    @IBOutlet var stackView: UIStackView!
    ///            ACTION BUTTONS
    @IBOutlet var segmentedControl: HBSegmentedControl!
    

    @IBAction func backButton(_ sender: UIBarButtonItem) {
     dismiss(animated: true, completion: nil)
    }
    @IBAction func okAction(_ sender: Any) {
        
        for i in EnumeratedSequence(array: [operationSpendingObjects]){
            if i.name == nameTextField.text {
                print("Такое имя существует!") /// Нужно исправить ошибку.
            }
        }
        saveElement()
    }
    @IBAction func addIconButton(_ sender: Any) {
        view.animateView(animatedView: blurView, frame: self.view)
        view.animateView(animatedView: popUpView, frame: self.view)
        view.endEditing(true) // Это для того случая, если пользователь выберет "Добавить иконку" до того, как скроется клавиатура
    }
    @IBAction func cancelGestureTipe(_ sender: Any) {
        view.reservedAnimateView(animatedView: blurView)
        view.reservedAnimateView(animatedView: popUpView)
        
        
    }
    
    
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    ///            IMAGES ARRAY
    let imagesForCollection = ["alcohol", "appliances", "bank", "bankCard", "books", "bowling", "cancel", "car", "carRepair", "carwash", "casino", "cellphone", "charity", "cigarettes", "cinema", "cleaning", "clothes", "construction", "cosmetics", "delivery", "dentist", "drugs", "education", "electricity", "error", "fitness", "flights", "flowers", "food", "fuel", "furniture", "games", "gas", "gifts", "glasses", "goverment", "hello", "hotel", "housing", "identification", "insurancy", "internet", "kids", "laundry", "lock", "luxuries", "magazine", "media", "medicine", "musicalInstruments", "other", "parking", "pets", "pool", "publicTransport", "purchases", "refill", "request", "send", "shoeRepair", "sport", "stadium", "stationery", "taxes", "taxi", "telephone", "tollRoad", "tourism", "toys", "trafficFine", "train", "tv", "unlock", "waterRransport", "withdraw"]
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
    }
    
    
    ///                     View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackViewSettings()
        middleTextLabel.text = middleText
        
        addCategory[1].text = bottomText
        //okNeomorph.bounds.origin.y = 700
        okNeomorph.cornerRadius = okNeomorph.bounds.height / 2
        segmentedControl.changeValuesForCashApp(segmentOne: "To you", segmentTwo: "From you")
        //navigationItem.setValue("Add", forKey: "title")
        
        setupNavigationController(Navigation: self.navigationController!)
        
        view.backgroundColor =  whiteThemeBackground
        collectionView.clipsToBounds = true
        nameTextField.delegate = self
        sumTextField.delegate = self
        //Делегаты для collectionView назначены в сториборде
        popUpAndBlurSize()
        whiteThemeColors()
        okOutlet.isEnabled = false
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        shadowForLabels()
        
        
    }
    
    ///                     TEXT FIELD FUNC
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        sumTextField.resignFirstResponder()
        
        return false
    }
    
    //              BLUR SIZE
    func popUpAndBlurSize() {
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.7, height: self.view.bounds.height*0.6)
        popUpView.layer.cornerRadius = 18
        blurView.bounds = self.view.bounds
        
    }
     
    func whiteThemeColors() {
        // labels
        selectDateLabel.textColor =    whiteThemeMainText
        imageView.setImageColor(color: whiteThemeMainText)
        okOutlet.setTitleColor(        whiteThemeMainText, for: .normal)
        okOutlet.setTitleColor(        whiteThemeTranslucentText, for: .disabled)
        okOutlet.setImageTintColor(whiteThemeTranslucentText)
        okOutlet.setShadow(view: okOutlet, size: CGSize(width: 1.5, height: 1.5), opacity: 0.4, radius: 4, color: whiteThemeMainText.cgColor)
        
        //textFields
//        nameTextField.backgroundColor = 
        nameTextField.textColor =      whiteThemeMainText
        sumTextField.backgroundColor = .none
        sumTextField.textColor =       whiteThemeMainText
        //text
        middleTextLabel.textColor =           whiteThemeRed
        //collectionView
        collectionView.layer.backgroundColor = .none
        //line
        popUpView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        for i in addCategory {
            i.textColor = whiteThemeMainText
        }
        ///Остальные настройки для TextField
        nameTextField.layer.cornerRadius = nameTextField.frame.height / 2
        sumTextField.layer.cornerRadius = sumTextField.frame.height / 2
        nameTextField.borderStyle = .none
        sumTextField.borderStyle = .none
        /// Изменение тайтла для кнопки добавления изображения
        
        
    }
    
    func stackViewSettings() {
        if self.view.bounds.height < 600 {
            stackView.spacing = 15
        } else {
            stackView.spacing = 22
        }
    }
    
    func shadowForLabels() {
        setCustomShadow(label: selectDateLabel, color: whiteThemeShadowText.cgColor, radius: 1, opacity: 0.3, size: CGSize(width: 1, height: 1))
    
        //Добавление лейблам тень
        for (_, element) in addCategory.enumerated(){
            setCustomShadow(label: element, color: whiteThemeMainText.cgColor, radius: 4, opacity: 0.6, size: CGSize(width: 2, height: 2))
        }
        setCustomShadow(label: middleTextLabel, color: whiteThemeTranslucentText.cgColor, radius: 4, opacity: 1, size: CGSize(width: 2, height: 2))
    }
    
    // Сохраняет элементы в базу
    func saveElement(){
        guard (nameTextField.text?.isEmpty) != nil else {return} //Проверка на всякий случай на присутствие текста
        addObject(text: nameTextField.text!, image: imageView.image, sum: Double(sumTextField.text!))
    }
    
    
    
    
    
    ///Проверка на пустую строку
    @objc private func textFieldChanged() {
        if nameTextField.text?.isEmpty == false {
            okOutlet.isEnabled = true
        } else {
            okOutlet.isEnabled = false
        }
    }
}




///                           COLLECTION VIEW


extension AddSpendingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource {
    
    
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
        imageView.image = selectedImage
        
        view.reservedAnimateView(animatedView: popUpView)
        view.reservedAnimateView(animatedView: blurView)
        
        
    }
    //                 UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesForCollection.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell
        let images = imagesForCollection[indexPath.item]
        let image = imageToData(imageName: images)
        cell.imageView.image = UIImage(data: image)
        cell.imageView.setImageColor(color: whiteThemeMainText)
        
        return cell
    }
    
    
    
}

