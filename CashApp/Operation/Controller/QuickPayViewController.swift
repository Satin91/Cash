//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar

class QuickPayViewController: UIViewController, DropDownProtocol, UITextFieldDelegate, UIScrollViewDelegate{
    func dropDownAccountNameAndIndexPath(string: String, indexPath: Int) {
        buttonLabel.text = string
        
        dropIndexPath = indexPath
        
        
    }
    
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
    var calendar = FSCalendarView()
    
    func dropDownAccountIdentifier(identifier: String) {
        accountIdentifier = identifier // Принял идентификатор из drop down table view
    }
    var pageOneView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    var pageTwoView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    dynamic var enteredSum = "0"
    var accountIdentifier = ""
    //var dropTableView = DropDownTableView()
    var dropIndexPath: Int?
    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
    var dropDownIsOpen = false
    var changeValue = true
    var commaIsPressed = false // Запятая
    var closePopUpMenuDelegate: PopUpProtocol!
    var dropDownProtocol: DropDownProtocol!
    var calendar1 = FSCalendar()
   
    
    ///             TEXT FIELD
    var popUpTextField =  UITextField()
    
    @IBAction func cancelAction(_ sender: Any) {
        popUpTextField.text = ""
        
        closePopUpMenuDelegate.closePopUpMenu(enteredSum: 0, indexPath: 0) // По уолчанию стоит 0, Это для того, чтобы сработала эта кнопка при любом случае
        
    }
    
    
    @IBAction func okAction(_ sender: Any) {
        dropDownProtocol.dropDownAccountIdentifier(identifier: accountIdentifier)//перенаправляет принятый идентификатор в следующий контроллер
        //guard let enteredSum = enteredSum  else {return}
        //Перевод запятой в точку для послдующей обработки
        let replaceEnteredSum = enteredSum.replacingOccurrences(of: ",", with: ".")
        let doubleEnteredSum = Double(replaceEnteredSum)
        guard doubleEnteredSum! > 0 else {return}
        closePopUpMenuDelegate.closePopUpMenu(enteredSum: doubleEnteredSum!, indexPath: dropIndexPath)
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
    @objc func changeOffset() {
        print("Offset changed")
        if isOffsetUsed == false, scrollView.contentOffset.x != scrollOffset
        {
            scrollView.contentOffset.x = scrollOffset
            isOffsetUsed = true
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let edge: CGFloat = 22
        let buttonHeight: CGFloat = 60
        let viewWidth = self.view.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        //let viewHeight = self.view.bounds.height * 0.75
        
        tableView.frame = CGRect(x: edge, y: edge, width: viewWidth - (edge * 2), height:scrollViewHeight)
        
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
    
   
   
    func addGradient(label: UILabel) {
        let gradientView = UIView(frame: label.bounds)

        // Create a gradient layer
        let gradient = CAGradientLayer()

        // gradient colors in order which they will visually appear
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        
        // Gradient from left to right
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        // set the gradient layer to the same size as the view
        gradient.frame = view.bounds
        // add the gradient layer to the views layer for rendering
        gradientView.layer.addSublayer(gradient)
        
        //let label = UILabel(frame: view.bounds)
        
        gradientView.addSubview(buttonLabel)
        
        // Tha magic! Set the label as the views mask
        gradientView.mask = buttonLabel
        label.setLabelSmallShadow(label: label)
        scrollView.addSubview(gradientView)
        
    }
    func pageControlSettings() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = whiteThemeTranslucentText
        pageControl.currentPageIndicatorTintColor = whiteThemeMainText
        pageControl.numberOfPages = 2
        
        
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
        addGradient(label: buttonLabel)
     
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        //registerForNotifications()
        
        // whiteThemeFunc()
        
        //  buttonLabel.text = "Choosse account"
        
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
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //При скроле происходит рассчет (смещение контента по Х деленное на частное из ширины скрол вью)
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(scrollView.bounds.width / 2))
        print("did scroll")
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
        //Цикл для того, чтобы сделать одну запятую в тексте
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

extension QuickPayViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuickTableViewCell", for: indexPath)
        return cell
    }
    
    
    
    
}

