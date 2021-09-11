//
//  AddAccountViewController.swift
//  CashApp
//
//  Created by Артур on 21.01.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

protocol scrollToNewAccount {
    func scrollToNewAccount(account: MonetaryAccount)
}
class AddAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let accountsImages = ["account1","account2","account3","account4"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountImageCell", for: indexPath) as! AccountImageCell
        cell.accImage.image = UIImage(named: accountsImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newAccountObject.imageForAccount = accountsImages[indexPath.row]
    }

    var indexForImage: IndexPath = [0,0]
    //Border neo bouds for textFields

    var scrollToNewAccountDelegate: scrollToNewAccount!
    var currency: String = {
        var currency = ""
        currency = mainCurrency == nil ? "USD": mainCurrency!.ISO
        return currency
    }()

    
    //Actions buttons
    @IBAction func createAccountAction(_ sender: Any) {
     
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
    @IBOutlet var accountsImageCollectionView: UIView!
    var newAccountObject = MonetaryAccount()
    //TextLabels
    @IBOutlet var headingTextLabel : UILabel!
    //TextFields
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var balanceTextField : NumberTextField!
    //Outlets
    @IBOutlet var saveButtonOutlet: ContrastButton!
    //Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        saveElement()
        scrollToNewAccountDelegate.scrollToNewAccount(account: newAccountObject)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func setupCollectionView() {
        let collectionView = AccountImagesCollectionView(frame: accountsImageCollectionView.bounds)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        accountsImageCollectionView.addSubview(collectionView)
        initConstraints(view: collectionView, to: accountsImageCollectionView)
        
        collectionView.collectionView.delegate = self
        collectionView.collectionView.dataSource = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        //setupNavigationController(Navigation: navigationController!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        visualSettings()
        setTextForViewElements()
    }
    
    func saveElement(){
        
        if !nameTextField.text!.isEmpty{
            newAccountObject.name = nameTextField.text!
        }
        if !balanceTextField.text!.isEmpty {
            newAccountObject.balance = Double(balanceTextField.text!.withoutSpaces)!
        }
        newAccountObject.currencyISO = currency
        DBManager.addAccountObject(object: [newAccountObject])
        
    }

    @objc func changeISO(_ sender: UIButton) {
        goToPopUpTableView(delegateController: self, payObject: userCurrencyObjects, sourseView: sender)
    }
    func setTextForViewElements() {
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field_placeholder", comment: "") , attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        balanceTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("balance_text_field_placeholder", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        balanceTextField.createRightButton(text: mainCurrency?.ISO ?? "")
        balanceTextField.button.addTarget(self, action: #selector(changeISO(_:) ), for: .touchUpInside)
        //Labels
        headingTextLabel.numberOfLines = 0
        headingTextLabel.text = NSLocalizedString("heading_label_text", comment: "")
    }
    
    
    

    func visualSettings(){
        self.view.backgroundColor = ThemeManager2.currentTheme().backgroundColor
        headingTextLabel.textColor = ThemeManager2.currentTheme().titleTextColor
        headingTextLabel.font = .systemFont(ofSize: 46, weight: .medium)
        nameTextField.changeVisualDesigh()
        balanceTextField.changeVisualDesigh()
        saveButtonOutlet.mainButtonTheme("save_button")
    }

    
    
    
}

extension AddAccountViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension AddAccountViewController: ClosePopUpTableViewProtocol {
    func closeTableView(object: Any) {
        let ISO = object as! CurrencyObject
        currency = ISO.ISO
        balanceTextField.button.setTitle(currency, for: .normal)
    }
    
    
}

