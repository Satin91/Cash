//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class QuickPayViewController: UIViewController, UIScrollViewDelegate{
    
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
    var convertedSumLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        
        return label
    }()
    
    
    
    
//    var accountIdentifier = ""
//    //var dropTableView = DropDownTableView()
//    var dropIndexPath: Int?
//    var dropDownHeight = NSLayoutConstraint() //переменная для хранения значения констрейнта
//    var dropDownIsOpen = false
//    var changeValue = true
//    var commaIsPressed = false // Запятая
    var closePopUpMenuDelegate: QuickPayCloseProtocol! // Под этот протокол подписан operationViewController
    var calendar = FSCalendarView()
    var date = Date()
    //Аккаунт для того чтобы поставить его первым
    var withoutAccountObject: MonetaryAccount = {
        var object = MonetaryAccount()
        object.name = "Without account"
        object.balance = 0
        object.accountID = "NO ACCOUNT"
        return object
    }()
    var selectedAccountObject: MonetaryAccount? = {
        var account: MonetaryAccount?
        for i in enumeratedALL(object: accountsObjects) {
            if i.isMainAccount == true{
             account = i
            }
        }
        guard account != nil else {return nil}
        
        return account
    }()
    var historyObject = AccountsHistory()
    //var payObject: MonetaryCategory?
    var payObject: Any! {
        
        willSet{
            switch newValue {
            case is MonetaryAccount:
                let object = newValue as! MonetaryAccount
                monetaryPaymentISO = object.currencyISO
            case is MonetaryCategory:
                let object = newValue as! MonetaryCategory
                monetaryPaymentISO = object.currencyISO
            case is MonetaryScheduler:
                let object = newValue as! MonetaryScheduler
                monetaryPaymentISO = object.currencyISO
            case is PayPerTime:
                let object = newValue as! PayPerTime
                monetaryPaymentISO = object.currencyISO
            default:
                monetaryPaymentISO = mainCurrency?.ISO
            }
        }
    }
    var sumTextField = NumberTextField()
    var convertedEnteredSum = Double(0)
    var monetaryPaymentISO: String?
    let currencyModelController = CurrencyModelController()
    var scrollOffset: CGFloat = 0
    var isOffsetUsed = false {
        didSet {
            guard oldValue == false else {return}
            scrollView.contentOffset.x = scrollOffset
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        sumTextField.text = ""
        closePopUpMenuDelegate.closePopUpMenu()
    }
    
    @IBAction func okAction(_ sender: Any) {
        let doubleEnteredSum = Double(sumTextField.enteredSum)
        guard doubleEnteredSum! > 0 else {return}
        newSave()
        closePopUpMenuDelegate.closePopUpMenu()
    }
    
    
    
    @objc func observeConvertedSum(){

        var currencyCarrier: String = mainCurrency!.ISO

        if selectedAccountObject != nil {
            currencyCarrier = selectedAccountObject!.currencyISO
        }else{
            currencyCarrier = mainCurrency!.ISO
        }
        
        if self.monetaryPaymentISO != currencyCarrier {
            //Конвертация валюты счета в валюту объекта
            let convertedSum = currencyModelController.convert(Double(sumTextField.enteredSum), inputCurrency: monetaryPaymentISO, outputCurrency: currencyCarrier)
            self.convertedEnteredSum = convertedSum!.removeHundredthsFromEnd()
            convertedSumLabel.text = convertedSum?.currencyFormatter(ISO: currencyCarrier)
        }else{
            convertedEnteredSum = 0
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(convertedSumLabel)
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
        checkPPTAndSetItValueToTextField()
        
        calendar = FSCalendarView(frame: .zero)//Границы календаря обусловлены констрейнтами, по этому фрейм можно ставить зиро
        tableView = QuickTableView(frame: .zero) // Аналогично
        scrollView.isPagingEnabled = true
        scrollView.addSubview(tableView)
        scrollView.addSubview(calendar)
        scrollView.addSubview(buttonLabel)
        scrollView.addSubview(sumTextField)
        //addGradient(label: buttonLabel)
        calendar.delegate = self
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        //registerForNotifications()
        addDoneButtonOnKeyboard()
        
    }
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let edge: CGFloat = 22
        let buttonHeight: CGFloat = 60
        let viewWidth = self.view.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        tableView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        tableView.frame = CGRect(x: edge, y: edge, width: viewWidth - (edge * 2), height:scrollViewHeight - (edge * 2))
        
        scrollOffset = self.view.bounds.width
        scrollView.contentSize = CGSize(width: viewWidth * 3, height: 1) // Height 1 для того чтобы нелзя было скролить по вертикали
        
        
        sumTextField.frame = CGRect(x: viewWidth, y: buttonHeight, width: viewWidth, height: scrollViewHeight - buttonHeight )
        convertedSumLabel.frame = sumTextField.bounds
        convertedSumLabel.frame.origin.x = convertedSumLabel.frame.origin.x + viewWidth / 2 - edge
        calendar.frame = CGRect(x: viewWidth * 2 + edge, y: edge, width: self.view.bounds.width - (edge * 2), height: scrollViewHeight - edge)
        buttonLabel.frame = CGRect(x: viewWidth + edge, y: 0, width: self.view.bounds.width - (edge * 2), height: buttonHeight)
        isOffsetUsed = true
        scrollView.contentSize.height = 1 // Disable vertical scroll
        
        
        self.view.layer.cornerRadius = 35
        self.view.clipsToBounds = true
        self.view.layer.masksToBounds = false
        self.view.setShadow(view: self.view, size: CGSize(width: 3, height: 4), opacity: 0.2, radius: 4, color: whiteThemeShadowText.cgColor)
    }
    func pageControlSettings() {
        pageControl.currentPage = 0 // Если поставить иное число, при загрузке происходит задержка первой страницы
        pageControl.pageIndicatorTintColor = whiteThemeTranslucentText
        pageControl.currentPageIndicatorTintColor = whiteThemeMainText
        pageControl.numberOfPages = 3
        
        
    }
    ///MARK: CHECK VALUE
    func checkPPTAndSetItValueToTextField() {
        if payObject is PayPerTime {
            let object = payObject as! PayPerTime
            sumTextField.text = String(object.target.formattedWithSeparator)
            sumTextField.enteredSum = String(object.target)
        }else if payObject is MonetaryScheduler {
            let object = payObject as! MonetaryScheduler
            if object.stringScheduleType == .oneTime {
                sumTextField.text = String(object.target - object.available)
                sumTextField.enteredSum = String(object.target - object.available)
            }
        }
    }
    
  
    func updatePPTArray(scheduleObject: MonetaryScheduler) -> [PayPerTime]?{
        var payArray = [PayPerTime]()
        for (_,i) in Array(payPerTimeObjects).enumerated() {
            if i.scheduleID == scheduleObject.scheduleID{
                payArray.append(i)
            }
        }
        if payArray.first != nil {
            return payArray
        }else{
            return nil
        }
    }
    func getLastRegularObject(scheduleObject: MonetaryScheduler) -> (firstObject:PayPerTime?,lastObject:PayPerTime?) {
        var calendarComponent = Calendar.Component.month
        switch scheduleObject.stringDateRhythm {
        case .week:
            calendarComponent = .weekOfMonth
        case .month:
            calendarComponent = .month
        case .none:
            break
        }
        var regularObject: PayPerTime?
        
        
        
            for (_,i) in Array(payPerTimeObjects).enumerated() {
                if i.scheduleID == scheduleObject.scheduleID{
                    regularObject = i
                
            }
        }
        guard let object = regularObject else {return (nil,nil)}
        let newNextObject = PayPerTime(scheduleName: scheduleObject.name, date: Calendar.current.date(byAdding: calendarComponent, value: 1, to: object.date)!, target: scheduleObject.sumPerTime, currencyISO: object.currencyISO, scheduleID: scheduleObject.scheduleID, vector: object.vector)
        return (regularObject,newNextObject)
    }
    ///Распределение для регулярного платежа
    func distributionForRegularObjects(scheduleObject:MonetaryScheduler, enteredSum : Double) {
        var enteredSum = enteredSum
        var cortage = getLastRegularObject(scheduleObject: scheduleObject)
        guard cortage.firstObject != nil else {return}
        
        if enteredSum > cortage.0!.target && scheduleObject.sumPerTime >= enteredSum {
            enteredSum -= cortage.firstObject!.target
            try! realm.write {
                cortage = getLastRegularObject(scheduleObject: scheduleObject)
                realm.add(cortage.1!)
                realm.delete(cortage.0!)
            }
        }
        while enteredSum >= scheduleObject.sumPerTime {
            try! realm.write {
                cortage = getLastRegularObject(scheduleObject: scheduleObject)
                realm.add(cortage.1!)
                realm.delete(cortage.0!)
            }
            enteredSum -= scheduleObject.sumPerTime
        }
        guard getLastRegularObject(scheduleObject: scheduleObject).firstObject != nil else {return}
        try! realm.write {
            cortage = getLastRegularObject(scheduleObject: scheduleObject)
            cortage.firstObject!.target -= enteredSum
            realm.add(cortage.firstObject!,update: .all)
        }
        
        
    }
    
    func sumEqualTargetOfMultiplyObjects(scheduleObject: MonetaryScheduler) {
        let scheduleObject = scheduleObject
        let payArray: [PayPerTime]? = updatePPTArray(scheduleObject: scheduleObject)
        try! realm.write {
            for i in payArray! {
                
                realm.delete(i)
            }
            realm.delete(scheduleObject)
        }
    }
    ///Распределение для многоразового платежа
    func distributionForMultiplyObjects(scheduleObject:MonetaryScheduler, enteredSum : Double) {
        var payArray: [PayPerTime]? = updatePPTArray(scheduleObject: scheduleObject)
        let scheduler = scheduleObject
        var arraySum = Double()
        var enteredSum = enteredSum
        try! realm.write {
            scheduleObject.available += enteredSum
            realm.add(scheduler,update: .all)
        }
       
        //Общая сумма ммассива
        for i in payArray! {
            arraySum += i.target
        }
        guard payArray != nil else{return}
        //чтобы объект не уходил в минус
        if enteredSum > payArray!.first!.target && scheduleObject.sumPerTime >= enteredSum {
            enteredSum -= payArray!.first!.target
            try! realm.write {
                realm.delete(payArray!.first!)
            }
        }
        //чтобы удалить план
        if enteredSum > arraySum {
            showAlert(message: "Завершить план?")
            try! realm.write {
                realm.delete(payArray!)
                payArray = nil
            }
        }else{
            //удалить разовые оплаты, которые входят в сумму общего платежа
            while enteredSum >= scheduleObject.sumPerTime {
                payArray = updatePPTArray(scheduleObject: scheduleObject)
                enteredSum -= payArray!.first!.target
                try! realm.write {
                    realm.delete(payArray!.first!)
                    // realm.add(updatePPTRegularOfArray(scheduleObject: scheduleObject)!)
                }
            }
        }
        payArray = updatePPTArray(scheduleObject: scheduleObject)
        //перенос остатка
        guard payArray != nil else {
            try! realm.write {
                realm.delete(scheduler)
            }
            return}
        payArray = updatePPTArray(scheduleObject: scheduleObject)
        try! realm.write {
            payArray!.first!.target -= enteredSum
            if payArray!.first!.target == 0 {
                realm.delete(payArray!.first!)
            }else{
            realm.add(payArray!.first!,update: .all)
            }
        }
        
        
    }
    func savePayPerTime(){
        var scheduleObject = MonetaryScheduler()
        let payPerTimeObject = payObject as! PayPerTime
        let enteredSum = Double(sumTextField.enteredSum)!
        
        
        for i in EnumeratedSchedulers(object: schedulerGroup) {
            if payPerTimeObject.scheduleID == i.scheduleID{
                scheduleObject = i
            }
        }
        historyObject.image = scheduleObject.image
        historyObject.name = scheduleObject.name
        historyObject.scheduleID = scheduleObject.scheduleID
        historyObject.payPerTimeID = payPerTimeObject.payPerTimeID
        //если сумма больше
        
        
        
        switch scheduleObject.stringScheduleType {
        
        
        ///MULTIPLY
        case .multiply:
            if enteredSum < payPerTimeObject.target {
                    try! realm.write {
                        payPerTimeObject.target -= enteredSum
                        realm.add(payPerTimeObject,update: .all)
                        scheduleObject.available += enteredSum
                        realm.add(scheduleObject,update: .all)
                    }
               
            }else if enteredSum == payPerTimeObject.target {
                //Это последний месяц кредита??
                enteredSum == (scheduleObject.target - scheduleObject.available) ? sumEqualTargetOfMultiplyObjects(scheduleObject: scheduleObject) : distributionForMultiplyObjects(scheduleObject: scheduleObject, enteredSum: enteredSum)
                
            }else if enteredSum > payPerTimeObject.target{
                enteredSum == (scheduleObject.target - scheduleObject.available) ? sumEqualTargetOfMultiplyObjects(scheduleObject: scheduleObject) : distributionForMultiplyObjects(scheduleObject: scheduleObject, enteredSum: enteredSum)
            }
            
        ///REGULAR
        case .regular:
            if enteredSum < payPerTimeObject.target {
            try! realm.write {
                scheduleObject.available += enteredSum
                realm.add(scheduleObject, update: .all)
                payPerTimeObject.target -= enteredSum
                realm.add(payPerTimeObject,update: .all)
            }
            }else if enteredSum == payPerTimeObject.target {
                try! realm.write {
                    ///удалить и поставить в конец новый объект регулярной оплаты
                    scheduleObject.available += enteredSum
                    realm.add(scheduleObject, update: .all)
                    realm.add(getLastRegularObject(scheduleObject: scheduleObject).lastObject!)
                    realm.delete(payPerTimeObject)
                    
                }
            }else if enteredSum > payPerTimeObject.target {
                distributionForRegularObjects(scheduleObject: scheduleObject, enteredSum: enteredSum)
                try! realm.write {
                    ///удалить и поставить в конец новый объект регулярной оплаты
                    scheduleObject.available += enteredSum
                    realm.add(scheduleObject, update: .all)
                }
            }
        default:
            break
        }
    }

    func saveHistorySum(vector: Bool){

        if vector {
            
            historyObject.sum = Double(sumTextField.enteredSum)!
            guard let iso = self.monetaryPaymentISO else {return}
            historyObject.currencyISO = iso
        }else {
            historyObject.sum = -Double(sumTextField.enteredSum)!
            guard let iso = self.monetaryPaymentISO else {return}
            historyObject.currencyISO = iso
            
        }
        guard convertedEnteredSum != 0 else {return}
        
        historyObject.convertedSum = vector ? convertedEnteredSum : -convertedEnteredSum
        
        
    }
    func saveCategory(convertedSum: Double) {
        let category = payObject as! MonetaryCategory
        historyObject.image = category.image
        historyObject.name = category.name
        historyObject.categoryID = category.categoryID
        try! realm.write {
            category.sum += historyObject.sum
            realm.add(category,update: .all)
        }
    }
    func saveScheduler() {
        var scheduleObject = payObject as! MonetaryScheduler
        for i in EnumeratedSchedulers(object: schedulerGroup) {
            if scheduleObject.scheduleID == i.scheduleID {
                scheduleObject = i
            }
        }
        historyObject.image = scheduleObject.image
        historyObject.name = scheduleObject.name
        historyObject.scheduleID = scheduleObject.scheduleID
        
        if scheduleObject.available + Double(sumTextField.enteredSum)! >= scheduleObject.target {
            self.showAlert(message: "Закрыть план?")
            try! realm.write {
                realm.delete(scheduleObject)
            }
        }else{
            try! realm.write {
                scheduleObject.available += Double(sumTextField.enteredSum)!
                realm.add(scheduleObject,update: .all)
            }
        }
        
    }
    
    func newSave() {
        //Настройки по умолчанию для всех типов транзакций
        historyObject.date = self.date
        historyObject.accountID = withoutAccountObject.accountID
        
        if payObject is MonetaryCategory {
            let object = payObject as! MonetaryCategory
            saveHistorySum(vector: object.vector)
           
            saveCategory(convertedSum: convertedEnteredSum)
        }else if payObject is PayPerTime {
            let object = payObject as! PayPerTime
            saveHistorySum(vector: object.vector)
            savePayPerTime()
        }else if payObject is MonetaryScheduler {
            let object = payObject as! MonetaryScheduler
            saveHistorySum(vector: object.vector)
            saveScheduler()
        }
        guard selectedAccountObject != nil else{
            DBManager.addHistoryObject(object: historyObject)
            return}
        //Если счет выбран
        historyObject.accountID = selectedAccountObject!.accountID
        try! realm.write {
            if convertedEnteredSum != 0 {
                
                selectedAccountObject!.balance += historyObject.convertedSum
            }else if convertedEnteredSum == 0 && selectedAccountObject?.currencyISO != monetaryPaymentISO{
                let convertedSum = currencyModelController.convert(historyObject.sum, inputCurrency: monetaryPaymentISO, outputCurrency: selectedAccountObject?.currencyISO)
                
                
                
                
                selectedAccountObject!.balance += convertedSum!
            }else{
                selectedAccountObject!.balance += historyObject.sum
            }
            let balance = selectedAccountObject?.balance.removeHundredthsFromEnd()
            selectedAccountObject?.balance = balance!
            realm.add(selectedAccountObject!,update: .all)
        }
        DBManager.addHistoryObject(object: historyObject)
    }
    func addDoneButtonOnKeyboard(){ // По сути это тоже самое как и в iqKeyboard только без нее
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        sumTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        sumTextField.resignFirstResponder()
        //popUpTextField.text! += ","
    }
    
    
    func buttonsSettings() {
        
        okButtonOutlet.backgroundColor = .clear
        cancelButtomOutlet.backgroundColor = .clear
        guard cancelButtomOutlet.titleLabel != nil,okButtonOutlet.titleLabel != nil  else {return}
        cancelButtomOutlet.setTitleColor( whiteThemeMainText, for: .normal)
        okButtonOutlet.setTitleColor( whiteThemeMainText, for: .normal)
        okButtonOutlet.setTitleColor(whiteThemeTranslucentText, for: .disabled)
    }
    func buttonLabelSettings() {
        buttonLabel = UILabel(frame: .zero)
        buttonLabel.textColor = whiteThemeRed
    }
    
    func textFiedldSettings() {
        sumTextField = NumberTextField(frame: .zero)
        sumTextField.borderStyle = .none
        sumTextField.font = UIFont.systemFont(ofSize: 46)
        sumTextField.textAlignment = .center
        sumTextField.textColor = whiteThemeMainText
        sumTextField.attributedPlaceholder = NSAttributedString(string: "Sum", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        sumTextField.addTarget(self, action: #selector(observeConvertedSum), for: .editingChanged)
        //        popUpTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        sumTextField.backgroundColor = .clear
        sumTextField.keyboardType = .decimalPad
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //При скроле происходит рассчет (смещение контента по Х деленное на частное из ширины скрол вью)
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
    
    
    func whiteThemeFunc() {
        buttonLabel.textColor = whiteThemeMainText
        self.view.backgroundColor = whiteThemeBackground
        buttonLabel.textColor = whiteThemeBackground
        sumTextField.textColor = whiteThemeMainText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sumTextField.resignFirstResponder()
        return false
    }
    
    deinit {
        
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
        var accounts = EnumeratedAccounts(array: accountsGroup) //Кастомная функция для добавления счета в массив
        if !accounts.isEmpty {
            accounts.append(withoutAccountObject) //дефолтная функция по добавлению
        }
        return accounts
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateAccounts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var appendAccount = enumeratedALL(object: accountsObjects) //EnumeratedAccounts(array: accountsGroup)
        for i in appendAccount {
            if i.isMainAccount {
                selectedAccountObject = i
            }
        }
        appendAccount.append(withoutAccountObject)
        let object = appendAccount[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuickTableViewCell", for: indexPath) as! QuickTableVIewCell
        cell.set(object: object)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = privateAccounts()[indexPath.row]
        guard object != privateAccounts().last else {
            selectedAccountObject = nil
            scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
            return}
        selectedAccountObject = object
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        
    }
    
    
}

///MARK: Calendar
extension QuickPayViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        self.date = date
    }
}
