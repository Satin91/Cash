//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar

class QuickPayViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    
    var tableView = QuickTableView()
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var okButtonOutlet: UIButton!
    @IBOutlet var cancelButtomOutlet: UIButton!
    
    var buttonLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.text = "Choose account"
        label.textColor = whiteThemeMainText
        return label
    }()
    
    
    
    dynamic var enteredSum = "0"
    var accountIdentifier = ""
    //var dropTableView = DropDownTableView()
    var dropIndexPath: Int?
    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
    var dropDownIsOpen = false
    var changeValue = true
    var commaIsPressed = false // Запятая
    var closePopUpMenuDelegate: PopUpProtocol! // Под этот протокол подписан operationController
    var calendar = FSCalendarView()
    
    //MARK: начинается заворужка с объектами
    var payObject: MonetaryEntity?
    var quickAccountObject: MonetaryAccount = {
        var object = MonetaryAccount()
        object.name = "Without account"
        object.balance = 0
        object.accountID = "NO ACCOUNT"
        return object
    }()
    var historyObject = AccountsHistory()
    
    
    ///             TEXT FIELD
    var popUpTextField =  UITextField()
    
    @IBAction func cancelAction(_ sender: Any) {
        popUpTextField.text = ""
        
        closePopUpMenuDelegate.closePopUpMenu(enteredSum: 0, indexPath: 0) // По уолчанию стоит 0, Это для того, чтобы сработала эта кнопка при любом случае
        
    }
    
    
    @IBAction func okAction(_ sender: Any) {
        //guard let enteredSum = enteredSum  else {return}
        //Перевод запятой в точку для послдующей обработки
        
        let replaceEnteredSum = enteredSum.replacingOccurrences(of: ",", with: ".")
        let doubleEnteredSum = Double(replaceEnteredSum)
        guard doubleEnteredSum! > 0 else {return}
        closePopUpMenuDelegate.closePopUpMenu(enteredSum: doubleEnteredSum!, indexPath: dropIndexPath)
        saveHistoryElement()
        
    }
    
    func saveHistoryElement() {
        guard payObject != nil else {return}
        historyObject.name = payObject!.name
        if historyObject.date == nil {
            historyObject.date = Date()
        }
        
        let replaceEnteredSum = enteredSum.replacingOccurrences(of: ",", with: ".")
        let doubleEnteredSum = Double(replaceEnteredSum)
        historyObject.sum = doubleEnteredSum!
        historyObject.image = payObject?.image
        historyObject.entityIdentifier = payObject!.monetaryID
        historyObject.accountIdentifier = quickAccountObject.accountID
        DBManager.addHistoryObject(object: historyObject)
        guard let indexPath = tableView.tableView.indexPathForSelectedRow?.row else {return}
        DBManager.updateAccount(accountType: appendAccounts(object: accountsObjects), indexPath: indexPath, addSum: doubleEnteredSum!)
        
    }
    
    func updateEntity() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    var scrollOffset: CGFloat = 0
    var isOffsetUsed = false {
        didSet {
            guard oldValue == false else {return}
            scrollView.contentOffset.x = scrollOffset
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let edge: CGFloat = 22
        let buttonHeight: CGFloat = 60
        let viewWidth = self.view.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        //let viewHeight = self.view.bounds.height * 0.75
        tableView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        tableView.frame = CGRect(x: edge, y: edge, width: viewWidth - (edge * 2), height:scrollViewHeight - (edge * 2))
        
        scrollOffset = self.view.bounds.width
        scrollView.contentSize = CGSize(width: viewWidth * 3, height: 1) // Height 1 для того чтобы нелзя было скролить по вертикали
        
        popUpTextField.frame = CGRect(x: viewWidth, y: buttonHeight, width: viewWidth, height: scrollViewHeight - buttonHeight )
        calendar.frame = CGRect(x: viewWidth * 2 + edge, y: edge, width: self.view.bounds.width - (edge * 2), height: scrollViewHeight - edge)
        buttonLabel.frame = CGRect(x: viewWidth + edge, y: 0, width: self.view.bounds.width - (edge * 2), height: buttonHeight)
        isOffsetUsed = true
        // gradientLayer(label: buttonLabel)
        
        
        
        
        scrollView.contentSize.height = 1 // Disable vertical scroll
        
        
        self.view.layer.cornerRadius = 35
        self.view.clipsToBounds = true
        self.view.layer.masksToBounds = false
        self.view.setShadow(view: self.view, size: CGSize(width: 3, height: 4), opacity: 0.2, radius: 4, color: whiteThemeShadowText.cgColor)
    }
    
    
    
    //    func addGradient(label: UILabel) {
    //        let gradientView = UIView(frame: label.bounds)
    //
    //        // Create a gradient layer
    //        let gradient = CAGradientLayer()
    //
    //        // gradient colors in order which they will visually appear
    //        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
    //
    //        // Gradient from left to right
    //        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    //        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
    //
    //        // set the gradient layer to the same size as the view
    //        gradient.frame = view.bounds
    //        // add the gradient layer to the views layer for rendering
    //        gradientView.layer.addSublayer(gradient)
    //
    //        //let label = UILabel(frame: view.bounds)
    //
    //        gradientView.addSubview(buttonLabel)
    //
    //        // Tha magic! Set the label as the views mask
    //        gradientView.mask = buttonLabel
    //        label.setLabelSmallShadow(label: label)
    //        scrollView.addSubview(gradientView)
    //
    //    }
    func pageControlSettings() {
        pageControl.currentPage = 0 // Если поставить иное число, при загрузке происходит задержка первой страницы
        pageControl.pageIndicatorTintColor = whiteThemeTranslucentText
        pageControl.currentPageIndicatorTintColor = whiteThemeMainText
        pageControl.numberOfPages = 3
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = whiteThemeBackground
        
        
        
        pageControlSettings()
        buttonsSettings()
        scrollView.contentSize = CGSize(width: 1200, height: 0)
        //NotificationCenter.default.addObserver(self, selector: #selector(changeOffset), name: nil, object: nil)
        scrollView.isScrollEnabled = true
        buttonLabel.textAlignment = .left
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        textFiedldSettings()
        
        
        calendar = FSCalendarView(frame: .zero)//Границы календаря обусловлены констрейнтами, по этому фрейм можно ставить зиро
        tableView = QuickTableView(frame: .zero) // Аналогично
        scrollView.isPagingEnabled = true
        scrollView.addSubview(tableView)
        scrollView.addSubview(calendar)
        scrollView.addSubview(buttonLabel)
        scrollView.addSubview(popUpTextField)
        //addGradient(label: buttonLabel)
        calendar.calendarView.delegate = self
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        //registerForNotifications()
        addDoneButtonOnKeyboard()
        
    }
    
    func addDoneButtonOnKeyboard(){ // По сути это тоже самое как и в iqKeyboard только без нее
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        popUpTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        popUpTextField.resignFirstResponder()
        //popUpTextField.text! += ","
    }
    
    
    func buttonsSettings() {
        let okNeomorph = NeoView()
        let cancelNeomorph = NeoView()
        
        
        okButtonOutlet.backgroundColor = .clear
        cancelButtomOutlet.backgroundColor = .clear
        guard cancelButtomOutlet.titleLabel != nil,okButtonOutlet.titleLabel != nil  else {return}
        okNeomorph.frame = okButtonOutlet.bounds
        okNeomorph.isExclusiveTouch = false
        okNeomorph.isUserInteractionEnabled = false
        
        
        cancelNeomorph.frame = okButtonOutlet.bounds
        cancelNeomorph.isExclusiveTouch = false
        cancelNeomorph.isUserInteractionEnabled = false
        
        
        
        cancelButtomOutlet.insertSubview(cancelNeomorph, at: 0)
        okButtonOutlet.insertSubview(okNeomorph, at: 0)
        
        cancelButtomOutlet.titleLabel!.setLabelSmallShadow(label: cancelButtomOutlet.titleLabel!)
        cancelButtomOutlet.setTitleColor( whiteThemeMainText, for: .normal)
        okButtonOutlet.titleLabel!.setLabelSmallShadow(label: okButtonOutlet.titleLabel!)
        okButtonOutlet.setTitleColor( whiteThemeMainText, for: .normal)
        okButtonOutlet.setTitleColor(whiteThemeTranslucentText, for: .disabled)
        
        
        
    }
    
    
    
    func buttonLabelSettings() {
        buttonLabel = UILabel(frame: .zero)
        buttonLabel.textColor = whiteThemeRed
        
    }
    func textFiedldSettings() {
        popUpTextField = UITextField(frame: .zero)
        popUpTextField.borderStyle = .none
        popUpTextField.font = UIFont.systemFont(ofSize: 46)
        popUpTextField.textAlignment = .center
        popUpTextField.textColor = whiteThemeMainText
        popUpTextField.attributedPlaceholder = NSAttributedString(string: "Sum", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        popUpTextField.delegate = self
        popUpTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        popUpTextField.backgroundColor = .clear
        popUpTextField.keyboardType = .decimalPad
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //При скроле происходит рассчет (смещение контента по Х деленное на частное из ширины скрол вью)
        //print(Int( scrollView.contentOffset.x))
        let halfWidth: CGFloat = scrollView.bounds.width / 2
        switch scrollView.contentOffset.x {
        case 0...halfWidth:
            pageControl.currentPage = 0
        case halfWidth...halfWidth * 3:
            pageControl.currentPage = 1
        case (halfWidth * 3)... :
            pageControl.currentPage = 2
        default:
            break
        }
    }
    
    ///Функция для запрета ввода букв
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = !string.isEmpty ? popUpTextField.text!.count + 1 : popUpTextField.text!.count - 1
        var allowedCharacters = CharacterSet(charactersIn: "0123456789")
        
        
        switch commaIsPressed {
        case true: // Запятая нажата
            allowedCharacters = CharacterSet(charactersIn: "0123456789")
        case false where length > 1: // запятая не нажата
            allowedCharacters = CharacterSet(charactersIn: ".0123456789")
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
    
    var zeroInFirstIndex = false
    @objc private func textFieldChanged() {
        guard popUpTextField.text?.isEmpty == false else {return}
        
        
        self.enteredSum = popUpTextField.text!
        //Цикл для того, чтобы сделать одну запятую в тексте
        for i in enteredSum {
            if i == "." {
                commaIsPressed = true
                return
            }else {
                commaIsPressed = false
            }
        }
        //оператор для установки запятой автоматически после нуля
        if popUpTextField.text?.count == 2, ((popUpTextField.text?.firstIndex(of: "0")) != nil) {
            popUpTextField.text?.insert(".", at:   popUpTextField.text!.index(  popUpTextField.text!.startIndex, offsetBy: 1))
            commaIsPressed = true
        }
    }
    
    
    
    func whiteThemeFunc() {
        buttonLabel.textColor = whiteThemeMainText
        self.view.backgroundColor = whiteThemeBackground
        buttonLabel.textColor = whiteThemeBackground
        popUpTextField.textColor = whiteThemeMainText
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
///MARK: Table view
extension QuickPayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func privateAccounts() -> [MonetaryAccount] {
        
        
        var accounts = appendAccounts(object: accountsObjects) //Кастомная функция для добавления счета в массив
        accounts.append(quickAccountObject) //дефолтная функция по добавлению
        return accounts
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return privateAccounts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var appendAccount = appendAccounts(object: accountsObjects)
        appendAccount.append(quickAccountObject)
        
        let object = appendAccount[indexPath.row]
        
        //    if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuickTableViewCell", for: indexPath) as! QuickTableVIewCell
        cell.set(object: object)
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = privateAccounts()[indexPath.row]
        quickAccountObject = object
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        
    }
    
    
}

///MARK: Calendar
extension QuickPayViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        historyObject.date = date
    }
}

