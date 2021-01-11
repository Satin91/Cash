//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit


class PopUpViewController: UIViewController, DropDownProtocol, UITextFieldDelegate{

    

    func dropDownIndexPath(indexPath: Int) {
        dropIndexPath = indexPath
    }
    
    var accountEntity = MonetaryEntity() // For dropDownMenu
    
    dynamic var textField: String = "0"
    
    var dropView = DropDownTableView()
    var dropIndexPath : Int?
    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
    var dropDownIsOpen = false
    
    var closeMenuDelegate: PopUpProtocol!
    
    @IBOutlet var choseYouAccountLabel: UILabel!
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet var gradientPopUpView: UIView!
    @IBOutlet var dropButtonView: GradientView!
    ///             TEXT FIELD
    @IBOutlet var popUpTextField: UITextField!
    
    @IBAction func cancelPopUpButton(_ sender: Any) {
        popUpTextField.text = ""
        closeMenuDelegate.closePopUpMenu(touch: "true")
        
        
    }
    
//    @IBAction func okPopUpAction(_ sender: Any) {
//        guard let indexPath = operationTableView.indexPathForSelectedRow else {return}
//        guard let dropPuth = dropIndexPath else {return}
//        monetaryEntity.sum = Double(textField)! //ДОДЕЛАТЬ ОБЯЗАТЕЛЬНО
//
//        DBManager.updateAccount(accountType: EnumeratedSequence(array: accountsObjects), indexPath: dropPuth, addSum: Double(textField)!)
//        DBManager.updateObject(objectType: EnumeratedSequence(array: changeValue ? operationPayment: operationScheduler), indexPath: indexPath.row, addSum: Double(textField)!) // Если что потом в operation Scheduler положить 'Box'
//
//        if textField != "0"{ DBManager.addObject(object: [monetaryEntity])
//        }else {print("Не создастся")}
//        popUpTextField.text = ""
//        operationTableView.reloadData()
//        self.view.reservedAnimateView(animatedView: blurView)
//        //self.view.reservedAnimateView(animatedView: popUpView)
//    }
    
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

    }
 
    func whiteThemeFunc() {
        choseYouAccountLabel.textColor = whiteThemeBackground
        self.view.backgroundColor = whiteThemeBackground
    }
    
    func dropDownAccountName(string: String) {
        choseYouAccountLabel.text = string
        closeDropDownMenu()
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
            self.textField = popUpTextField.text!    //// Функция для того чтобы текстфилд не вернул нил
        } else {
            self.textField = "0"
        }
        print(textField)
        
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
    


