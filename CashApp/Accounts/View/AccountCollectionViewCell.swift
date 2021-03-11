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
    
    @IBOutlet var headerTextField: UITextField!
    @IBOutlet var sumTextField: UITextField!
    @IBOutlet var balanceLabel: UILabel!
    var accountsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        changeTFPropherties(textField: headerTextField)
        changeTFPropherties(textField: sumTextField)
        editButtonOutlet.setImage(UIImage(named: "Edit"), for: .normal)
        accountsImageView = UIImageView(frame: self.bounds)
        cellBackground.insertSubview(accountsImageView, at: 0)
        initConstraints(view: accountsImageView, to: cellBackground)
        headerTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        sumTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name(rawValue: "TextFieldIsEnabled"), object: nil)
        self.layer.cornerRadius = 19
        self.clipsToBounds = true
    }
    
    func changeTFPropherties(textField: UITextField) {
        
        textField.font = UIFont.systemFont(ofSize: 46)
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.borderStyle = .none
        textField.isEnabled = false
    }
    
    @objc func didEndEditing(_ sender: UITextField) {
        guard delegate != nil else {return}
        
        var whoIsEditing = "NoTextFieldEditing"
        
        if headerTextField.isEditing {
            whoIsEditing = "HeaderIsEditing"
        }else if sumTextField.isEditing {
            whoIsEditing = "SumIsEditing"
        }
        
        print(whoIsEditing)
        
        delegate!.cellTextFieldChanged(self, didEndEditingWithText: sender.text, textFieldName: whoIsEditing)
    }
    
    func setForSelect(image: UIImage, name: String,sum: String, account: MonetaryAccount) {
        headerTextField.text = name
        sumTextField.text = sum
        accountsImageView.image = image
    }
    
    func set(image: UIImage, name: String,sum: String, account: MonetaryAccount) {
        headerTextField.text = name
        sumTextField.text =  String(account.balance.currencyFR)
        accountsImageView.image = image
    }
    @objc func receive(notification: NSNotification) {
        let notf = notification.userInfo!["CASE"] as! Bool
        if notf {
            headerTextField.isEnabled = true
            sumTextField.isEnabled = true
        }else {
            headerTextField.isEnabled = false
            sumTextField.isEnabled = false
        }
    }
}


