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
    var delegate: CellTappedProtocol!
    var separatorView = AccountCellSeparatorView(frame: .zero)
    var closure: ((Bool) -> Void)?
    lazy var advancedMethods = AccountCellAdvanced(label: isMainAccountLabel)
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet var cellBackground: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var balanceTextField: NumberTextField!
    var accountsImageView: UIImageView!
    var accountObject: MonetaryAccount!
    var editMode: Bool? {
        willSet {
            editButtomChangeValue(toggle: newValue!)
        }
    }
    @IBOutlet var isMainAccountLabel: UILabel!
    @IBAction func editButtonAction(_ sender: UIButton) {
        editMode!.toggle()
        buttomAction(succes: editMode!, completion: closure!) // Отправляет замыкание в коллекцию
        switch editMode {
        case true:
            setForEnableEditing()
        case false:
            setForDisableEditing()
        case .none:
            break
        case .some(_):
            break
        }
        // delegate.tapped(tapped: true)
    }
    var lockView: LockView!
    func buttomAction( succes: Bool, completion: (Bool) -> Void)  {
        completion(succes)
    }
  
    func setAccount(account: MonetaryAccount) {
        
        nameTextField.text = account.name
        balanceTextField.text =  String(account.balance.currencyFormatter(ISO: account.currencyISO))
        accountsImageView.image = UIImage(named: account.imageForAccount)
        ///эта функция нужна здесь, потому что только тут происходит инициализация значений
        //  advancedMethods.disableUnderLine(textField: nameTextField) //disableUnderLine(textField: nameTextField)
        // advancedMethods.disableUnderLine(textField: balanceTextField)
        accountObject = account
        advancedMethods.setIsMainAccount(account: account)
        
    }
    
    func setForDisableEditing() {
        balanceTextField.text = accountObject.balance.currencyFormatter(ISO: accountObject.currencyISO)
        advancedMethods.disableUnderLine(textField: nameTextField)
        advancedMethods.disableUnderLine(textField: balanceTextField)
        editButtonOutlet.backgroundColor = colors.titleTextColor
    }
    func setForEnableEditing() {
        nameTextField.text = accountObject.name
        balanceTextField.text = String(Double(accountObject.balance).formattedWithSeparator.replacingOccurrences(of: ".", with: ","))
        advancedMethods.enableUnderLine(textField: nameTextField)
        advancedMethods.enableUnderLine(textField: balanceTextField)
        editButtonOutlet.backgroundColor = colors.contrastColor1
    }
    func lock(_ isLock: Bool) {
        lockView.lock(!isLock)
    }
    func editButtomChangeValue(toggle: Bool) {
        switch toggle {
        case true:
            setForEnableEditing()
        case false:
            setForDisableEditing()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lockView = LockView(frame: .zero)
        colors.loadColors()
        visualSettings()
        constraintsForSeparator()
        cellBackground.insertSubview(accountsImageView, at: 0)
        initConstraints(view: accountsImageView, to: cellBackground)
        nameTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        balanceTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingChanged)
        nameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name(rawValue: "IsEnabledTextField"), object: nil)
    }
    func constraintsForSeparator() {
        self.addSubview(separatorView)
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.separatorView.topAnchor.constraint(equalTo: self.balanceTextField.topAnchor,constant: -8)
        ])
        
    }
    
    func changeIsMainAccountLabelVisibility() {
        if accountObject.isMainAccount == true {
            UIView.animate(withDuration: 0.2) {
                self.isMainAccountLabel.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.2) {
                self.isMainAccountLabel.alpha = 0
            }
        }
    }
    
    func setColors() {
        editButtonOutlet.layer.setSmallShadow(color: colors.shadowColor)
        editButtonOutlet.setImageTintColor(colors.backgroundcolor, imageName: "Edit")
        self.layer.setMiddleShadow(color: colors.shadowColor)
        balanceTextField.textColor = .white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lockView.addLock(to: self, lockSize: .plan)
    }
    
    func visualSettings() {
        self.setColors()
       
        balanceTextField.updateTextColor = false
        changeTFPropherties(textField: nameTextField)
        changeTFPropherties(textField: balanceTextField)
        editButtonOutlet.setImage(UIImage(named: "Edit"), for: .normal)
        editButtonOutlet.layer.cornerRadius = 12
        editButtonOutlet.layer.setSmallShadow(color: colors.shadowColor)
       
       
        //accountsImageView.layer.masksToBounds = false
        accountsImageView = UIImageView(frame: self.bounds)
        self.layer.cornerRadius = 22
        self.layer.cornerCurve = .continuous
        
        balanceTextField.font = UIFont(name: "Ubuntu-Bold",size: 34)
        self.isMainAccountLabel.text = "● Главный счет"
        self.isMainAccountLabel.textColor = colors.whiteColor
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.cellBackground.backgroundColor = .clear
        self.cellBackground.clipsToBounds = false
        self.cellBackground.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
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
    
    
    @objc func didEndEditing(_ sender: UITextField) {
        if nameTextField.isEditing {
            
            try! realm.write({
                self.accountObject.name = sender.text ?? " "
                
                realm.add(accountObject,update: .all)
            })
        }else if balanceTextField.isEditing {
            let sender = sender as! NumberTextField
            let text = sender.enteredSum //.formattedWithSeparator.replacingOccurrences(of: ".", with: ",")
            do {
                try realm.write({
                    accountObject.balance = Double( text )!
                    realm.add(accountObject,update: .all)
                })
            } catch {
                let alertView = MiniAlertView(frame: .zero)
                alertView.showMiniAlert(message: "Не удалось записать данные", alertStyle: .warning)
            }
        }
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
        advancedMethods.disableUnderLine(textField: textField) // disableUnderLine(textField: textField)
    }
    
}
