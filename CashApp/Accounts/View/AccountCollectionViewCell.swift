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
    
    @IBAction func editButtonAction(_ sender: Any) {
        delegate.tapped(tapped: true)
    }
    @IBOutlet var editButtonOutlet: UIButton!
    @IBOutlet var cellBackground: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var balanceTextField: NumberTextField!
    @IBOutlet var balanceLabel: UILabel!
    var accountsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        changeTFPropherties(textField: nameTextField)
        changeTFPropherties(textField: balanceTextField)
        editButtonOutlet.setImage(UIImage(named: "Edit"), for: .normal)
        accountsImageView = UIImageView(frame: self.bounds)
        cellBackground.insertSubview(accountsImageView, at: 0)
        initConstraints(view: accountsImageView, to: cellBackground)
        nameTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        balanceTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        
        nameTextField.delegate = self
        
       // nameTextField.addTarget(self, action: #selector(touchOnTextField(_:)), for: .allTouchEvents)
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil)
    }
    
    func changeTFPropherties(textField: UITextField) {
        textField.font = UIFont.systemFont(ofSize: 34)
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.borderStyle = .none
        textField.isEnabled = false
        balanceTextField.textAlignment = .right
        
    }
    
    
    @objc func didEndEditing(_ sender: UITextField) {
        guard delegate != nil else {return}
        var whoIsEditing = "NoTextFieldEditing"
        if nameTextField.isEditing {
            whoIsEditing = "HeaderIsEditing"
        }else if balanceTextField.isEditing {
            whoIsEditing = "BalanceIsEditing"
            
        }else{
        }
        delegate!.cellTextFieldChanged(self, didEndEditingWithText: sender.text, textFieldName: whoIsEditing)
    }
    
    func setForSelect(image: UIImage, name: String, balance: String, account: MonetaryAccount) {
        
        nameTextField.text = name
        balanceTextField.text = balance
        accountsImageView.image = image

        enableUnderLine(textField: nameTextField)
        
    }
    
    func setAccount(account: MonetaryAccount) {
        nameTextField.text = account.name
        balanceTextField.text =  String(account.balance.currencyFR)
        accountsImageView.image = UIImage(named: account.imageForAccount)
        ///эта функция нужна здесь, потому что только тут происходит инициализация значений
        disableUnderLine(textField: nameTextField)
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
