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
import IQKeyboardManagerSwift


class AddOperationViewController: UIViewController, UITextFieldDelegate, SendIconToParentViewController{
    let colors = AppColors()
    
    
    
    func sendIconName(name: String) {
        selectedImageName = name
        
        selectImageButton.setImageView(imageName: name, color: colors.titleTextColor)
        //selectImageButton. = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    @IBOutlet var scrollView: UIScrollView!//нужен только для того, чтобы выключить скрол(до следующих обновлений с лимитом)
    
    //Protocol for reload data to previous table view
    var tableReloadDelegate: ReloadParentTableView!
    var ImageCollectionView: IconsViewController!
    var miniAlertView: MiniAlertView!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var containerForSaveButton: UIView!
    
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
    
    @IBOutlet var selectImageButton: UIButton!
    
    var navBarButtons: NavigationBarButtons!
    
    var selectedImageName = "emptyImage" {
        didSet{
            Themer.shared.register(target: self, action: AddOperationViewController.theme(_:))
            
        }
    }
    var iconsCollectionView = IconsViewController()
    @IBAction func selectImageButtonAction(_ sender: Any) {
        present(iconsCollectionView, animated: true) {
            self.iconsCollectionView.sendImageDelegate = self
        }
    }
    func setupNavBar() {
        let colors = AppColors()
        colors.loadColors()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        
        appearance.backgroundEffect = UIBlurEffect(style: Themer.shared.theme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark) // or dark
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular),NSAttributedString.Key.foregroundColor: colors.titleTextColor]
        let scrollingAppearance = UINavigationBarAppearance()
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 26 - 12
        paragraphStyle.alignment = .left
        scrollingAppearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 46, weight: .medium), .paragraphStyle: paragraphStyle, .foregroundColor: colors.titleTextColor  ]
        
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = .clear // your view (superview) color
        scrollingAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular),NSAttributedString.Key.foregroundColor: colors.titleTextColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollingAppearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    ///                     View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        Themer.shared.register(target: self, action: AddOperationViewController.theme(_:))
        colors.loadColors()
        
        miniAlertView = MiniAlertView.loadFromNib()
        scrollView.isScrollEnabled = true
        miniAlertView.controller = self
        self.isModalInPresentation = true
        visualSettings()
        setupNavBar()
        iconsCollectionView.sendImageDelegate = self
        setupControls()
        setupNavBarButtons()
    }
    func setupNavBarButtons() {
        self.navBarButtons = NavigationBarButtons(navigationItem: navigationItem, leftButton: .none, rightButton: .cancel)
        self.navBarButtons.setRightButtonAction { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    // Этот участок обязательно переделать, одна функция запускается 2 раза подряд, но почему то только так можно установить ограничения для скрол вью
    override func viewDidAppear(_ animated: Bool) {
        scrollViewContentSize()
    }
    func layoutFUCK() {
        nameTextField.layoutIfNeeded()
        nameTextField.layoutSubviews()
        nameTextField.layer.layoutIfNeeded()
        nameTextField.layer.layoutSublayers()
        for i in nameTextField.layer.sublayers! {
            i.frame = nameTextField.bounds
            print(i.frame)
            print(nameTextField.bounds)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewContentSize()
    }
    func scrollViewContentSize() {
        let frame = nameTextField.convert(saveButtonOutlet.frame, from: self.scrollView)
        let height = abs(frame.origin.y - 60 - 40)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: height)
    }
    
    
    func setupControls() {
        
        nameTextField.delegate = self
    }
    
    func visualSettings() {
        headingTextLabel.numberOfLines = 2
        headingTextLabel.font = .systemFont(ofSize: 34, weight: .bold)
        headingTextLabel.minimumScaleFactor = 0.5
        headingTextLabel.sizeToFit()
        selectImageButton.layer.cornerRadius = 25
        containerForSaveButton.backgroundColor = colors.backgroundcolor
        
        let saveButtomTitle = isEditingCategory ? NSLocalizedString("save_button", comment: "") : NSLocalizedString("create_button", comment: "")
        saveButtonOutlet.mainButtonTheme(saveButtomTitle)
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        isEditingCategory == true ? setDataForEditableControls() : setDataForСreatingControls()
        Themer.shared.register(target: self, action: AddOperationViewController.theme(_:))
        
    }
    
    
    
    ///                     TEXT FIELD FUNC
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }
    
    
    
}
extension AddOperationViewController {
    func theme(_ theme: MyTheme) {
        print("Theme")
        nameTextField.borderedTheme(fillColor: theme.settings.secondaryBackgroundColor, shadowColor: theme.settings.shadowColor)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: theme.settings.subtitleTextColor ])
        view.backgroundColor = theme.settings.backgroundColor
        selectImageButton.layer.setMiddleShadow(color: theme.settings.shadowColor)
        selectImageButton.backgroundColor = theme.settings.secondaryBackgroundColor
        selectImageButton.setImageView(imageName: selectedImageName, color: theme.settings.titleTextColor)
        
    }
}
extension UIButton {
    func setImageView(imageName: String, color: UIColor) {
        for i in self.subviews {
            i.removeFromSuperview()
        }
        let buttonImage = UIImageView(frame: self.bounds)
        buttonImage.image = UIImage().myImageList(systemName: imageName)
        buttonImage.contentMode = .scaleAspectFit
        buttonImage.tintColor = color
        // Если иконка кастомная:
        buttonImage.setImageColor(color: color)
        buttonImage.frame = buttonImage.bounds.inset(by: UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18))
        self.addSubview(buttonImage)
        if buttonImage.bounds.width < 34 {
            let sideLayout: CGFloat = 0 // buttonImage.bounds.width / 7
            buttonImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: sideLayout),
                buttonImage.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -sideLayout),
                buttonImage.topAnchor.constraint(equalTo: self.topAnchor,constant: sideLayout),
                buttonImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -sideLayout)
            ])
 //           initConstraints(view: buttonImage, to: self)
        }
    }
}
