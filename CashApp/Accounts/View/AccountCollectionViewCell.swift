//
//  AccountCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 4.03.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol collectionCellProtocol {
    func tapped(tapped: Bool)
    func cellTextFieldChanged(_ levelTableViewCell: AccountCollectionViewCell, didEndEditingWithText: String?, textFieldName: String!)
}


class AccountCollectionViewCell: UICollectionViewCell {
    
    let identifier = "AccountCell"
    var delegate: collectionCellProtocol!
    
    @IBOutlet var isMainAccountOutlet: UISwitch!
    
    @IBAction func isMineAccountAction(_ sender: UISwitch) {
        changeMineAccountProperties(sender: sender.isOn)
    }
     

    
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        print("tapped")
        delegate.tapped(tapped: true)
    }
    @IBOutlet var editButtonOutlet: UIButton!
    @IBOutlet var cellBackground: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var balanceTextField: NumberTextField!
    var accountsImageView: UIImageView!
    var accountObject = MonetaryAccount()
    
    func visualSettings() {
        changeTFPropherties(textField: nameTextField)
        changeTFPropherties(textField: balanceTextField)
        self.layer.cornerRadius = 25
        self.layer.cornerCurve = .continuous
        accountsImageView = UIImageView(frame: self.bounds)
        self.clipsToBounds = true
        balanceTextField.font = UIFont(name:"Ubuntu-Bold",size: 34)
        editButtonOutlet.setImage(UIImage(named: "Edit"), for: .normal)
        self.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        visualSettings()
        cellBackground.insertSubview(accountsImageView, at: 0)
        initConstraints(view: accountsImageView, to: cellBackground)
        nameTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        balanceTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        nameTextField.delegate = self
        
        
        //nameTextField.addTarget(self, action: #selector(touchOnTextField(_:)), for: .allTouchEvents)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil)
    }
    
    func changeTFPropherties(textField: UITextField) {
        textField.font = .systemFont(ofSize: 34, weight: .regular)
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.borderStyle = .none
        textField.isEnabled = false
        balanceTextField.textAlignment = .right
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil)
    }
    func changeMineAccountProperties(sender: Bool) {
        
        for i in EnumeratedAccounts(array: accountsGroup) {
            try! realm.write {
            i.isMainAccount = false
                realm.add(i, update: .all)
            }
            try! realm.write {
            accountObject.isMainAccount = sender
                realm.add(accountObject, update: .all)
            }
        }
    }
    
    @objc func didEndEditing(_ sender: UITextField) {
        guard delegate != nil else {return}
        var whoIsEditing = "NoTextFieldEditing"
        if nameTextField.isEditing {
            
            whoIsEditing = "HeaderIsEditing"
            let text = sender 
            delegate!.cellTextFieldChanged(self, didEndEditingWithText: text.text, textFieldName: whoIsEditing)
            
        }else if balanceTextField.isEditing {
            
            whoIsEditing = "BalanceIsEditing"
            let text = sender as! NumberTextField
            delegate!.cellTextFieldChanged(self, didEndEditingWithText: text.enteredSum, textFieldName: whoIsEditing)
            
        }else{
        }
        
        
    }
    
    func setForSelect(image: UIImage, name: String, balance: String, account: MonetaryAccount) {
        
        nameTextField.text = name
        balanceTextField.text = String(Double(balance)!.formattedWithSeparator.replacingOccurrences(of: ".", with: ","))
        accountsImageView.image = image
        enableUnderLine(textField: nameTextField)
        
    }
    
    func setAccount(account: MonetaryAccount) {
        isMainAccountOutlet.isOn = account.isMainAccount
        nameTextField.text = account.name
        balanceTextField.text =  String(account.balance.currencyFormatter(ISO: account.currencyISO))
        accountsImageView.image = UIImage(named: account.imageForAccount)
        ///эта функция нужна здесь, потому что только тут происходит инициализация значений
        disableUnderLine(textField: nameTextField)
        accountObject = account
    }
    
    
    func enableUnderLine(textField: UITextField) {
        let attributedString = NSMutableAttributedString(string: textField.text!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            textField.attributedText = attributedString
    }
    
    func disableUnderLine(textField: UITextField){
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: textField.text!)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        textField.attributedText = attributeString
    }
    
    
    @objc func receive(notification: NSNotification) {
        let notf = notification.userInfo!["CASE"] as! Bool
        if notf {
            nameTextField.isEnabled = true
            balanceTextField.isEnabled = true
        }else{
            nameTextField.isEnabled = false
            balanceTextField.isEnabled = false
            
        }
    }
}


extension AccountCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        disableUnderLine(textField: textField)
    }
}
