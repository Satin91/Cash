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
class AddAccountViewController: UIViewController {

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
 
    var newAccountObject = MonetaryAccount()
    //TextLabels
    @IBOutlet var headingTextLabel : UILabel!
    //TextFields
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var balanceTextField : NumberTextField!
    //Outlets
    @IBOutlet var saveButtonOutlet: UIButton!
    //Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        saveElement()
        scrollToNewAccountDelegate.scrollToNewAccount(account: newAccountObject)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        balanceTextField.attributedPlaceholder = NSAttributedString(string: "Balance", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        balanceTextField.createRightButton(text: mainCurrency?.ISO ?? "")
        balanceTextField.button.addTarget(self, action: #selector(changeISO(_:) ), for: .touchUpInside)
        navigationItem.rightBarButtonItem?.title = "Create"
        navigationItem.leftBarButtonItem?.title = "Cancel"
        //Labels
        headingTextLabel.numberOfLines = 0
        headingTextLabel.text = "Add new naccount"
    }
    
    
    

    func visualSettings(){
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        headingTextLabel.textColor = ThemeManager.currentTheme().titleTextColor
        nameTextField.changeVisualDesigh()
        balanceTextField.changeVisualDesigh()
        saveButtonOutlet.mainButtonTheme(color: ThemeManager.currentTheme().contrastColor1, "Create")
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

