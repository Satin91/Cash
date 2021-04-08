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
    @IBOutlet var balanceTextField: UITextField!
    @IBOutlet var balanceLabel: UILabel!
    var accountsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        changeTFPropherties(textField: headerTextField)
        changeTFPropherties(textField: balanceTextField)
        editButtonOutlet.setImage(UIImage(named: "Edit"), for: .normal)
        accountsImageView = UIImageView(frame: self.bounds)
        cellBackground.insertSubview(accountsImageView, at: 0)
        initConstraints(view: accountsImageView, to: cellBackground)
        headerTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        balanceTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
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
    }
    
    @objc func didEndEditing(_ sender: UITextField) {
        guard delegate != nil else {return}
        
        var whoIsEditing = "NoTextFieldEditing"
        if headerTextField.isEditing {
            whoIsEditing = "HeaderIsEditing"
        }else if balanceTextField.isEditing {
            whoIsEditing = "BalanceIsEditing"
        }        
        delegate!.cellTextFieldChanged(self, didEndEditingWithText: sender.text, textFieldName: whoIsEditing)
    }
    
    func setForSelect(image: UIImage, name: String, balance: String, account: MonetaryAccount) {
     
        headerTextField.text = name
        balanceTextField.text = balance
        accountsImageView.image = image
        
    }

    
    func setAccount(account: MonetaryAccount) {
        headerTextField.text = account.name
        balanceTextField.text =  String(account.balance.currencyFR)
        accountsImageView.image = UIImage(named: account.imageForAccount)
        
    }
    @objc func receive(notification: NSNotification) {
        let notf = notification.userInfo!["CASE"] as! Bool
        if notf {
            headerTextField.isEnabled = true
            balanceTextField.isEnabled = true
        }else{
            headerTextField.isEnabled = false
            balanceTextField.isEnabled = false
        }
    }
}


