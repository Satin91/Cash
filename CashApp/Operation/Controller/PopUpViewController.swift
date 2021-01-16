//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit


class PopUpViewController: UIViewController, DropDownProtocol, UITextFieldDelegate{
    
    
    func dropDownAccountNameAndIndexPath(string: String, indexPath: Int) {
        buttonLabel.text = string
        dropIndexPath = indexPath
        closeDropDownMenu()
    }
    func dropDownAccountIdentifier(identifier: String) {
        accountIdentifier = identifier
    }
    
    //var accountEntity = MonetaryEntity() // For dropDownMenu
    
    dynamic var enteredSum: String?
    var accountIdentifier = ""
    var dropView = DropDownTableView()
    var dropIndexPath: Int?
    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
    var dropDownIsOpen = false
    var changeValue = true
    var closePopUpMenuDelegate: PopUpProtocol!
    var dropDownProtocol: DropDownProtocol!
    
    @IBOutlet var buttonLabel: UILabel!

    

    @IBOutlet var gradientPopUpView: UIView!
    @IBOutlet var dropButtonView: GradientView!
    ///             TEXT FIELD
    @IBOutlet var popUpTextField: UITextField!
    
    @IBAction func cancelPopUpButton(_ sender: Any) {
        popUpTextField.text = ""
        
        closePopUpMenuDelegate.closePopUpMenu(touch: "0", indexPath: 0) // По уолчанию стоит 0, Это для того, чтобы сработала эта кнопка при любом случае
        
    }
    
    
    @IBAction func okPopUpAction(_ sender: Any) {
        dropDownProtocol.dropDownAccountIdentifier(identifier: accountIdentifier)
        guard let enteredSum = enteredSum  else {return}
        
        //Если индекс есть и указана сумма,                 при этом индекс не 0 и указана сумма
        
        closePopUpMenuDelegate.closePopUpMenu(touch: enteredSum, indexPath: dropIndexPath)
    }
    

    @IBAction func dropMenuButton(_ sender: UIButton) {
        if dropDownIsOpen == false {
            openDropDownMenu()
        }else{
            closeDropDownMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        popUpTextField.delegate = self
        popUpTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        initDropDownTableView()
        whiteThemeFunc()
        dropView.dropDelegate = self
   
        buttonLabel.text = "Choosse account"
        
        
        
    }
    
    func whiteThemeFunc() {
        buttonLabel.textColor = whiteThemeMainText
        self.view.backgroundColor = whiteThemeBackground
        buttonLabel.textColor = whiteThemeBackground
    }
    
   
    func initDropDownTableView() {
        dropView = DropDownTableView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dropView)
        //Делает отображение поверх других вьюх
        self.view.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: dropButtonView.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: dropButtonView.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: dropButtonView.widthAnchor).isActive = true
        dropDownHeight = dropView.heightAnchor.constraint(equalToConstant: 0)
        dropDownHeight.isActive = true
    }
    
    func closeDropDownMenu() {
        dropDownIsOpen = false
        NSLayoutConstraint.deactivate([self.dropDownHeight])
        dropDownHeight.constant = 0
        NSLayoutConstraint.activate([self.dropDownHeight])
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeLinear, animations: { [self] in
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()  //Позиция должна быть пересчитана
            
        } )
    }
    
    func openDropDownMenu() {
        dropDownIsOpen = true
        NSLayoutConstraint.deactivate([self.dropDownHeight])
        dropDownHeight.constant = self.view.frame.height - dropButtonView.frame.height
        NSLayoutConstraint.activate([self.dropDownHeight])
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeLinear, animations: {
            self.dropView.layoutIfNeeded() //Позиция должна быть пересчитана
            self.dropView.center.y += self.dropView.frame.height / 2
        } )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        popUpTextField.resignFirstResponder()
        return false
    }
    
    @objc private func textFieldChanged() {
        if popUpTextField.text?.isEmpty == false {
            self.enteredSum = popUpTextField.text!    //// Функция для того чтобы текстфилд не вернул нил
        } else {
            self.enteredSum = nil
        }
       // print(enteredSum)
        
    }
    
    deinit {
        print("Deinit popUpView")
        removeKeyboardNotifications()
    }
    
    func registerForNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        
        //Дело в том, что виличина непостоянная не принимается свифтом как уверенная и свифт постоянно прибавляет значения после
        //нажатия на textField. Frame непостоянная, bounds же всегда почемуто извнстна
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //нужно разобраться еще
        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.bounds.origin.y + keyboardSize.height / 3)
    }
    
    @objc func kbWillHide (_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y + keyboardSize.height / 3 )
        
    }
    
}



