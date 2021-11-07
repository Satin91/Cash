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
class AddAccountViewController: UIViewController  {
    
    let colors = AppColors()
    let accountsImages = ["account1","account2","account3","account4"]
    @IBOutlet var scrollView: UIScrollView!
    var cancelButton: CancelButton!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
    @IBOutlet var headingTextLabel : TitleLabel!
    //TextFields
    @IBOutlet var nameTextField : ThemableTextField!
    @IBOutlet var balanceTextField : NumberTextField!
    //Outlets
    @IBOutlet var saveButtonOutlet: ContrastButton!
    //Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        saveElement()
        scrollToNewAccountDelegate.scrollToNewAccount(account: newAccountObject)
        dismiss(animated: true, completion: nil)
        
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
        colors.loadColors()
        self.setColors()
        cancelButton = CancelButton(frame: .zero, title: .cancel, owner: self)
        cancelButton.addToScrollView(view: self.scrollView)
        setupCollectionView()
        //setupNavigationController(Navigation: navigationController!)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        balanceTextField.createRightButton(text: mainCurrency?.ISO ?? "")
    }
    @objc func changeISO(_ sender: UIButton) {
        goToPopUpTableView(delegateController: self, payObject: userCurrencyObjects, sourseView: sender, type: .currency)
    }
    func setTextForViewElements() {
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field_placeholder", comment: "") , attributes: [NSAttributedString.Key.foregroundColor: colors.subtitleTextColor ])
        balanceTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("balance_text_field_placeholder", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: colors.subtitleTextColor ])
        
        balanceTextField.button.addTarget(self, action: #selector(changeISO(_:) ), for: .touchUpInside)
        
        //Labels
        
        headingTextLabel.numberOfLines = 2
        headingTextLabel.textAlignment = .left
        headingTextLabel.font = .systemFont(ofSize: 46, weight: .bold)
        headingTextLabel.text = NSLocalizedString("heading_label_text", comment: "")
    }
    
    
    

    func visualSettings(){
       
        headingTextLabel.font = .systemFont(ofSize: 46, weight: .medium)
        
        saveButtonOutlet.mainButtonTheme("save_button")
    }

    
    
    
}
extension AddAccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountImageCell", for: indexPath) as! AccountImageCell
        cell.accImage.image = UIImage(named: accountsImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newAccountObject.imageForAccount = accountsImages[indexPath.row]
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

