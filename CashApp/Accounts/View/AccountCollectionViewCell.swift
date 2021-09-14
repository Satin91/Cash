//
//  AccountCollectionViewCell.swift
//  CashApp
//
//  Created by Артур on 4.03.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


class AccountCollectionViewCell: UICollectionViewCell {
    let colors = AppColors()
    let identifier = "AccountCell"
    var delegate: collectionCellProtocol!
    
    
    
    
    ///    changeMineAccountProperties(sender: sender.isOn)
    
    
    
    
    func setColors(){
        editButtonOutlet.layer.setSmallShadow(color: colors.shadowColor)
        editButtonOutlet.setImageTintColor(colors.backgroundcolor, imageName: "Edit")
        self.layer.setMiddleShadow(color: colors.shadowColor)
        balanceTextField.textColor = .white
    }
    @IBAction func editButtonAction(_ sender: UIButton) {
        toggle.toggle()
        delegate.tapped(tapped: true)
    }
    @IBOutlet var editButtonOutlet: UIButton!
    @IBOutlet var cellBackground: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var balanceTextField: NumberTextField!
    var accountsImageView: UIImageView!
    var accountObject = MonetaryAccount()
    var toggle: Bool = false {
        willSet {
            buttonSettings(toggle: newValue)
        }
    }
    func buttonSettings(toggle: Bool) {
        editButtonOutlet.setImage(UIImage(named: "Edit"), for: .normal)
        editButtonOutlet.layer.cornerRadius = 12
        switch toggle {
        case true:
            editButtonOutlet.backgroundColor = colors.contrastColor1
            
        case false:
            editButtonOutlet.backgroundColor = colors.titleTextColor
            
        }
        
    }
    func visualSettings() {
        changeTFPropherties(textField: nameTextField)
        changeTFPropherties(textField: balanceTextField)
        self.layer.cornerRadius = 22
        self.layer.cornerCurve = .continuous
        accountsImageView = UIImageView(frame: self.bounds)
        self.clipsToBounds = true
        balanceTextField.font = UIFont(name:"Ubuntu-Bold",size: 34)
        buttonSettings(toggle: toggle)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colors.loadColors()
        self.setColors()
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
