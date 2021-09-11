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
import Themer



class AddOperationViewController: UIViewController, UITextFieldDelegate, SendIconToParentViewController{
    
    func sendIconName(name: String) {
        selectedImageName = name
    }
    
    
    //Protocol for reload data to previous table view
    var tableReloadDelegate: ReloadParentTableView!
    var ImageCollectionView: IconsCollectionView!
    var miniAlertView: MiniAlertView!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    var newCategoryObject = MonetaryCategory()
    var changeValue = true
    
    lazy var isEditingCategory = false
    var vector: Bool = false
    
    
    ///             [BLUR, POPUP, COLLECTION]
    @IBOutlet var blurView: UIVisualEffectView!
    //TextLabels
    @IBOutlet var headingTextLabel: TitleLabel!
    @IBOutlet var descriptionLabel: SubTitleLabel!
    
    ///                TEXT FIELDS
    @IBOutlet var nameTextField: ThemableTextField!
    
    ///            ACTION BUTTONS
    @IBOutlet var saveButtonOutlet: ContrastButton!
    @IBAction func saveButtonAction(_ sender: Any) {
        guard saveElement() else {return}
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
        
      
        
    
    var selectedImageName = "emptyImage" {
        didSet{
            Themer.shared.register(target: self, action: AddOperationViewController.theme(_:))
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
        Themer.shared.register(target: self, action: AddOperationViewController.theme(_:))
        miniAlertView = MiniAlertView.loadFromNib()
        miniAlertView.controller = self
        visualSettings()
        iconsCollectionView.sendImageDelegate = self
        setupControls()
        print(isEditingCategory)
        
    }
    
    
    func setupControls() {
        
        nameTextField.delegate = self
    }
    
    func visualSettings() {
        headingTextLabel.numberOfLines = 0
        headingTextLabel.font = .systemFont(ofSize: 34, weight: .medium)
       
        selectImageButton.layer.cornerRadius = 25
        let saveButtomTitle = isEditingCategory ? NSLocalizedString("save_button", comment: "") : NSLocalizedString("create_button", comment: "")
        saveButtonOutlet.mainButtonTheme(saveButtomTitle)
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .light)
        isEditingCategory == true ? setDataForEditableControls() : setDataForСreatingControls()
        Themer.shared.register(target: self, action: AddOperationViewController.theme(_:))
        self.isModalInPresentation = false
    }
    
    
    
    ///                     TEXT FIELD FUNC
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }
    
    
    
}
extension AddOperationViewController {
     func theme(_ theme: MyTheme) {
        nameTextField.borderedTheme(fillColor: theme.settings.backgroundColor, shadowColor: theme.settings.shadowColor)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: theme.settings.subtitleTextColor ])
        view.backgroundColor = theme.settings.backgroundColor
        selectImageButton.backgroundColor = theme.settings.secondaryBackgroundColor
        selectImageButton.setImageTintColor(theme.settings.titleTextColor, imageName: selectedImageName)
    }
}