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
    
    func goToAddVC(restorationIdentifier: String) {
        
    }
    
    var newEntityElement = MonetaryEntity()
    var changeValue = true
    let pointBetweenItems = 15
    var textForUpperLabel = ""
    var textForMiddleLabel = "" // Переменная для принятия текста из других классов
    var textForBottomLabel = "" // Переменная для принятия текста из других классов
    
    ///                OUTLETS
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var okOutlet: UIButton!
    //exit в сториборде
    @IBOutlet var imageView: UIImageView!
    //TextLabels
    @IBOutlet var upperTextLabel: UILabel!
    @IBOutlet var middleTextLabel: UILabel!
    @IBOutlet var bottomTextLabel: UILabel!
    
    
    
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var nameBorderButton: BorderButtonView!
    @IBOutlet var sumBorderButton: BorderButtonView!
    @IBOutlet var secondSumBorderButton: BorderButtonView!
    @IBOutlet var okNeomorph: NeomorphicView!
    @IBOutlet var segmentedontrolNeomorph: NeomorphicView!
    
    ///                TEXT FIELDS
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var sumTextField: UITextField!
    @IBOutlet var secondSumTextField: UITextField!
    
    ///              STACK
    @IBOutlet var stackView: UIStackView!
    ///            ACTION BUTTONS
    @IBOutlet var segmentedControl: HBSegmentedControl!
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
       
    }
    @IBAction func okAction(_ sender: Any) {
        
        for i in EnumeratedSequence(array: [expenceObjects]){
            if i.name == nameTextField.text {
                print("Такое имя существует!") /// Не знаю нафига исправлять эту ошибку, если все происходит по идентификатору
            }
        }
        saveElement()
    }
    @IBAction func addIconButton(_ sender: Any) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
        
    }
    ///                     View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        viewSelection()
        stackViewSettings()
        upperTextLabel.text = textForUpperLabel
        middleTextLabel.text = textForMiddleLabel
        bottomTextLabel.text = textForBottomLabel
        //okNeomorph.bounds.origin.y = 700
        okNeomorph.cornerRadius = okNeomorph.bounds.height / 2
        segmentedControl.changeValuesForCashApp(segmentOne: "To you", segmentTwo: "From you")
        //navigationItem.setValue("Add", forKey: "title")
        setupNavigationController(Navigation: self.navigationController!)
        collectionView.clipsToBounds = true
        //Делегаты для collectionView назначены в сториборде
        popUpAndBlurSize()
        whiteThemeColors()
        okOutlet.isEnabled = false
        shadows()
        setupButtonsAndFields()
    }
    
    ///               view selection func
    func viewSelection(){
        switch newEntityElement.stringEntityType {
        case .approach:
            sumTextField.isHidden = false
            sumBorderButton.isHidden = false
            secondSumTextField.isHidden = true
            secondSumBorderButton.isHidden = true
            segmentedControl.isHidden = false
            segmentedontrolNeomorph.isHidden = false
            selectDateButton.isHidden = false
            selectDateView.isHidden = false
        case .debt :
            sumTextField.isHidden = false
            sumBorderButton.isHidden = false
            secondSumTextField.isHidden = false
            secondSumBorderButton.isHidden = false
            segmentedControl.isHidden = true
            segmentedontrolNeomorph.isHidden = true
            selectDateButton.isHidden = false
            selectDateView.isHidden = false
        case .regular:
            //sum
            sumTextField.isHidden = false
            sumBorderButton.isHidden = false
            //secondSum
            secondSumTextField.isHidden = true
            secondSumBorderButton.isHidden = true
            //segmented
            segmentedControl.isHidden = true
            segmentedontrolNeomorph.isHidden = true
            //date button
            selectDateButton.isHidden = false
            selectDateView.isHidden = false
        case .expence:
            //sum
            sumTextField.isHidden = true
            sumBorderButton.isHidden = true
            //secondSum
            secondSumTextField.isHidden = true
            secondSumBorderButton.isHidden = true
            //date button
            selectDateButton.isHidden = true
            selectDateView.isHidden = true
            //segmented
            segmentedControl.isHidden = true
            segmentedontrolNeomorph.isHidden = true
        }
    }
    
    ///                     TEXT FIELD FUNC
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        sumTextField.resignFirstResponder()
        return false
    }
    func setupButtonsAndFields() {
        selectDateButton.setTitle("Select date", for: .normal)
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        //nameTextField.placeholder = "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        sumTextField.attributedPlaceholder = NSAttributedString(string: "Sum", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        
        nameTextField.delegate = self
        sumTextField.delegate = self
    }
    
    //              BLUR SIZE
    func popUpAndBlurSize() {
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.7, height: self.view.bounds.height*0.6)
        popUpView.layer.cornerRadius = 18
        blurView.bounds = self.view.bounds
        
    }
    
    func whiteThemeColors() {
        // labels
        selectDateButton.setTitleColor(whiteThemeMainText, for: .normal)
        imageView.setImageColor(color: whiteThemeMainText)
        okOutlet.setTitleColor(        whiteThemeMainText, for: .normal)
        okOutlet.setTitleColor(        whiteThemeTranslucentText, for: .disabled)
        okOutlet.setImageTintColor(whiteThemeTranslucentText)
        //shadow
        nameTextField.textColor =      whiteThemeMainText
        sumTextField.backgroundColor = .none
        sumTextField.textColor =       whiteThemeMainText
        //text
        middleTextLabel.textColor =    whiteThemeRed
        //collectionView
        collectionView.layer.backgroundColor = .none
        //line
        popUpView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        upperTextLabel.textColor = whiteThemeMainText
        middleTextLabel.textColor = whiteThemeRed
        bottomTextLabel.textColor = whiteThemeMainText
        ///Остальные настройки для TextField
        
        nameTextField.borderStyle = .none
        sumTextField.borderStyle = .none
        //Остальные view
        self.view.backgroundColor =  whiteThemeBackground
        
        
    }
    
    func stackViewSettings() {
        if self.view.bounds.height < 600 {
            stackView.spacing = 15
        } else {
            stackView.spacing = 22
        }
    }
    
    func shadows() {
        guard let buttonLabel = selectDateButton.titleLabel else {return}
        
        okOutlet.setShadow(view: okOutlet, size: CGSize(width: 1.5, height: 1.5), opacity: 0.4, radius: 4, color: whiteThemeMainText.cgColor)
        //Добавление лейблам тень
        buttonLabel.setLabelSmallShadow(label: buttonLabel)
        upperTextLabel.setLabelMiddleShadow(label: upperTextLabel)
        middleTextLabel.setLabelMiddleShadow(label: middleTextLabel)
        bottomTextLabel.setLabelMiddleShadow(label: bottomTextLabel)
        
    }
    
    // Сохраняет элементы в базу
    func saveElement(){
        guard (nameTextField.text?.isEmpty) != nil else {return} //Проверка на всякий случай на присутствие текста
        if ((secondSumTextField.text?.isEmpty) != nil) {
            secondSumTextField.text = "0"
        }
        addObject(text: nameTextField.text!, image: imageView.image, sum: Double(sumTextField.text!), secondSum: Double(secondSumTextField.text!), type: MonetaryType(rawValue: newEntityElement.accountType)!)
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
