//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit


class PopUpViewController: UIViewController, DropDownProtocol, UITextFieldDelegate{
    
    let neiroView = NeomorphicView()
    func dropDownAccountNameAndIndexPath(string: String, indexPath: Int) {
        buttonLabel.text = string
      
        dropIndexPath = indexPath
        
        closeDropDownMenu()
    }
    func dropDownAccountIdentifier(identifier: String) {
        accountIdentifier = identifier // Принял идентификатор из drop down table view
    }

    dynamic var enteredSum = "0"
    var accountIdentifier = ""
    var dropView = DropDownTableView()
    var dropIndexPath: Int?
    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
    var dropDownIsOpen = false
    var changeValue = true
    var commaIsPressed = false // Запятая
    var closePopUpMenuDelegate: PopUpProtocol!
    var dropDownProtocol: DropDownProtocol!
    
    @IBOutlet var buttonLabel: UILabel!

    @IBOutlet var dropButtonView: GradientView!
    @IBOutlet var borderButtonView: BorderButtonView!
    ///             TEXT FIELD
    @IBOutlet var popUpTextField: UITextField!
    
    @IBAction func cancelPopUpButton(_ sender: Any) {
        popUpTextField.text = ""
        
        closePopUpMenuDelegate.closePopUpMenu(enteredSum: 0, indexPath: 0) // По уолчанию стоит 0, Это для того, чтобы сработала эта кнопка при любом случае
        
    }
    
    
    @IBAction func okPopUpAction(_ sender: Any) {
        dropDownProtocol.dropDownAccountIdentifier(identifier: accountIdentifier)//перенаправляет принятый идентификатор в следующий контроллер
        //guard let enteredSum = enteredSum  else {return}
        //Перевод запятой в точку для послдующей обработки
        let replaceEnteredSum = enteredSum.replacingOccurrences(of: ",", with: ".")
        let doubleEnteredSum = Double(replaceEnteredSum)
        guard doubleEnteredSum! > 0 else {return}
        
        closePopUpMenuDelegate.closePopUpMenu(enteredSum: doubleEnteredSum!, indexPath: dropIndexPath)
    }
    
    
    @IBAction func dropMenuButton(_ sender: UIButton) {
        if dropDownIsOpen == false {
            openDropDownMenu()
        }else{
            closeDropDownMenu()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.frame = CGRect(x: super.view.frame.width / 2, y: super.view.frame.height / 2, width: super.view.frame.width * 0.8, height: super.view.bounds.height * 0.5)
        //self.view.bounds = super.view.bounds
        popUpTextField.borderStyle = .none
        registerForNotifications()
        popUpTextField.delegate = self
        popUpTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        initDropDownTableView()
        whiteThemeFunc()
        dropView.dropDelegate = self
        buttonLabel.text = "Choosse account"
        popUpTextField.attributedPlaceholder = NSAttributedString(string: "Sum", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropButtonView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        dropButtonView.clipsToBounds = true
        dropButtonView.selectivelyRoundedRadius(usingCorners: [.topRight,.topLeft], radius: CGSize(width: 20 , height: 20), view: dropButtonView)
        self.view.layer.cornerRadius = 21
        self.view.setShadow(view: self.view, size: CGSize(width: 3, height: 4), opacity: 0.2, radius: 4, color: whiteThemeShadowText.cgColor)
    }
 
    
    ///Функция для запрета ввода букв
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = !string.isEmpty ? popUpTextField.text!.count + 1 : popUpTextField.text!.count - 1
        var allowedCharacters = CharacterSet(charactersIn: "0123456789")
        
        switch commaIsPressed {
        case true: // Запятая нажата
             allowedCharacters = CharacterSet(charactersIn: "0123456789")
        case false where length > 1: // запятая не нажата
             allowedCharacters = CharacterSet(charactersIn: ",0123456789")
        default:
            allowedCharacters = CharacterSet(charactersIn: "0123456789")
        }
        
        
        
        let characterSet = CharacterSet(charactersIn: string)
        
        //Ограничение по количеству символов
        if length > 9 {
            return false
        }
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
   
    
    @objc private func textFieldChanged() {
        guard popUpTextField.text?.isEmpty == false else {return}
        self.enteredSum = popUpTextField.text!
        
        //Цикл для того, чтобы сделать запятую одну в тексте
        for i in enteredSum {
            if i == "," {
                commaIsPressed = true
                //allowedCharacters = CharacterSet(charactersIn: "0123456789")
                return
            }else {
                commaIsPressed = false
                //allowedCharacters = CharacterSet(charactersIn: ",0123456789")
            }
        }
        
        
        
    }
    
    func whiteThemeFunc() {
        buttonLabel.textColor = whiteThemeMainText
        self.view.backgroundColor = whiteThemeBackground
        buttonLabel.textColor = whiteThemeBackground
        popUpTextField.textColor = whiteThemeMainText
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
            self.dropView.layoutIfNeeded()  //Позволяет менять констрейнты в реальном времени
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
            self.dropView.selectivelyRoundedRadius(usingCorners: [.bottomLeft,.bottomRight], radius: CGSize(width: self.view.layer.cornerRadius , height: self.view.layer.cornerRadius), view: self.dropView)
        } )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        popUpTextField.resignFirstResponder()
        return false
    }
    
    
    
    deinit {
        print("Deinit popUpView прошел успешно")
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



