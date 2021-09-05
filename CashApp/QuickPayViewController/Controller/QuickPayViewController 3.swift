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
    
    @IBOutlet var okButtonOutlet: UIButton!
    @IBOutlet var cancelButtomOutlet: UIButton!
    
    var payObjectNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = ThemeManager.currentTheme().secondaryBackgroundColor
        label.text = "ObjectNameError"
        label.font = .systemFont(ofSize: 26,weight: .regular)
        return label
    }()
    var accountLabel: UILabel = {
        var label = UILabel()
        label.textColor = ThemeManager.currentTheme().secondaryBackgroundColor
        label.text = "AccountNameError"
        label.font = .systemFont(ofSize: 17,weight: .regular)
        return label
    }()
    var dateLabel: UILabel = {
        var label = UILabel()
        label.textColor = ThemeManager.currentTheme().secondaryBackgroundColor
        label.text = "Today"
        label.font = .systemFont(ofSize: 17,weight: .regular)
        return label
    }()
    
    
    var convertedSumLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        
        label.font = .systemFont(ofSize: 26, weight: .regular)
        label.textColor = ThemeManager.currentTheme().secondaryBackgroundColor
        
        return label
    }()
    var sumTextField: NumberTextField = {
        let tf = NumberTextField()
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.textAlignment = .right
        tf.textColor = ThemeManager.currentTheme().backgroundColor
        tf.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().borderColor ])
        tf.addTarget(self, action: #selector(observeConvertedSum), for: .editingChanged)
        tf.font = .systemFont(ofSize: 54, weight: .regular)
        
        tf.minimumFontSize = 26
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()
    var numpadView = NumpadView()
  
    
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
   
    var convertedEnteredSum = Double(0)
    var monetaryPaymentISO: String?
    let currencyModelController = CurrencyModelController()
    var scrollOffset: CGFloat = 0
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.currentTheme().titleTextColor
        return view
    }()
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
        print(observeConvertedSum)
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
        if sumTextField.enteredSum == "0"{
            convertedSumLabel.text = " "
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        payObjectNameLabel.textAlignment = .left
        tableView = QuickTableView(frame: .zero) // Аналогично
        calendar.delegate = self
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        tableView.layer.masksToBounds = false
        tableView.clipsToBounds = false
        setupContainerView()
        setupScrollView()
        checkPayObjectAndSetItsValue()
        
        //registerForNotifications()
        //addDoneButtonOnKeyboard()
    }
    
    func setupScrollView() {
        scrollView.contentSize = CGSize(width: 1200, height: 0)
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    func setupContainerView(){
        scrollView.addSubview(tableView)
        scrollView.addSubview(calendar)
        scrollView.addSubview(containerView)
        scrollView.addSubview(numpadView)
        numpadView.delegate = self
        numpadView.delegateAction = self
        containerView.addSubview(convertedSumLabel)
        containerView.addSubview(payObjectNameLabel)
        containerView.addSubview(sumTextField)
        containerView.addSubview(accountLabel)
        containerView.addSubview(dateLabel)
        createConstraints()
    }
    func createConstraints() {
        convertedSumLabel.translatesAutoresizingMaskIntoConstraints = false
        payObjectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        numpadView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            convertedSumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -26),
            convertedSumLabel.bottomAnchor.constraint(equalTo: sumTextField.topAnchor, constant: -8),
           
            sumTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -26),
            sumTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            sumTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -26),
            
            payObjectNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            payObjectNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            
            accountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            accountLabel.topAnchor.constraint(equalTo: payObjectNameLabel.bottomAnchor, constant: 8),
            
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            dateLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            
            numpadView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            numpadView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            numpadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            numpadView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let edge: CGFloat = 22
        let viewWidth = self.view.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        
        scrollOffset = self.view.bounds.width
        scrollView.contentSize = CGSize(width: viewWidth * 3, height: 1) // Height 1 для того чтобы нелзя было скролить по вертикали
        
        containerView.frame = CGRect(x: viewWidth, y: 0, width: viewWidth, height: scrollViewHeight / 2)
//        sumTextField.frame = CGRect(x: viewWidth, y: buttonHeight, width: viewWidth, height: scrollViewHeight - buttonHeight )
//        convertedSumLabel.frame = sumTextField.bounds
//        convertedSumLabel.frame.origin.x = convertedSumLabel.frame.origin.x + viewWidth / 2 - edge
        calendar.frame = CGRect(x: viewWidth * 2 + edge, y: edge, width: self.view.bounds.width - (edge * 2), height: scrollViewHeight - edge)
        //payObjectNameLabel.frame = CGRect(x: viewWidth + edge, y: 0, width: self.view.bounds.width - (edge * 2), height: buttonHeight)
        isOffsetUsed = true
        scrollView.contentSize.height = 1 // Disable vertical scroll
    }
    
    ///MARK: CHECK VALUE
    func checkPayObjectAndSetItsValue() {
        if payObject is PayPerTime {
            let object = payObject as! PayPerTime
            sumTextField.text = String(object.target.formattedWithSeparator)
            sumTextField.enteredSum = String(object.target)
            payObjectNameLabel.text = object.scheduleName
        }else if payObject is MonetaryScheduler {
            let object = payObject as! MonetaryScheduler
            payObjectNameLabel.text = object.name
            if object.stringScheduleType == .oneTime {
                payObjectNameLabel.text = object.name
                sumTextField.text = String(object.target - object.available)
                sumTextField.enteredSum = String(object.target - object.available)
            }
        }else if payObject is MonetaryCategory {
            let object = payObject as! MonetaryCategory
            payObjectNameLabel.text = object.name
        }
        accountLabel.text = selectedAccountObject != nil ? selectedAccountObject?.name : "Without account"
        
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
        case .month:
            calendarComponent = .month
        case .week:
            calendarComponent = .weekOfMonth
        case .day:
            calendarComponent = .day
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
                if scheduleObject.stringScheduleType != .oneTime { //запретил onetime чтобы не возникало ошибок в дневном бюджете
                    scheduleObject.available += Double(sumTextField.enteredSum)!
                    
                }else{
                    scheduleObject.target -= Double(sumTextField.enteredSum)!
                }
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

    
    func whiteThemeFunc() {
        payObjectNameLabel.textColor = whiteThemeMainText
        self.view.backgroundColor = whiteThemeBackground
        payObjectNameLabel.textColor = whiteThemeBackground
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
        return 100
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
        accountLabel.text = object.name
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        
    }
    
}
extension QuickPayViewController: TappedNumbers {
    
    func checkComma(text: String, comma: inout Bool) {
        for i in text {
            if i == "," {
                 comma.toggle()
            }
        }
    }
    func sendNumber(number: String) {
        var comma = false
        
        sumTextField.inputView = numpadView
        comma = sumTextField.checkComma(string: sumTextField.text!)
        print(comma)
        print(number)
        
        if number != "Save" {
        if sumTextField.text?.isEmpty == true && number != "," {
            sumTextField.text?.append(number)
            sumTextField.textFieldChanged()
            self.observeConvertedSum()

        }else if sumTextField.text?.isEmpty == false && number == ","  && comma == false {
            sumTextField.text?.append(number)
            sumTextField.textFieldChanged()
            self.observeConvertedSum()
        }else if sumTextField.text?.isEmpty == false && number != "," {
            sumTextField.text?.append(number)
            sumTextField.textFieldChanged()
            self.observeConvertedSum()
        }
        }
        
    
       
        
        
        //sumTextField.insertText(number)
        if number == "Save" {
            let doubleEnteredSum = Double(sumTextField.enteredSum)
            guard doubleEnteredSum! > 0 else {return}
            newSave()
            dismiss(animated: true, completion: nil)
            
        }else {
        }
        
        
        
        //sumTextField.deleteBackward()
        
        
//        sumTextField.textFieldChanged()
//        self.observeConvertedSum()
    }
    
    
}
extension QuickPayViewController:  tappedButtons{
    func scrollAndBackspace(action: String) {
        
        let x: CGFloat = action == "Accounts" ? 0 : self.view.bounds.width * 2.8
       
        switch action {
        case "Backspace":
            guard sumTextField.text != "" else {return}
            sumTextField.text?.removeLast()
            sumTextField.textFieldChanged()
        observeConvertedSum()
        default:
            scrollView.scrollRectToVisible(CGRect(x: x, y: 0, width: self.view.bounds.width / 3, height: self.view.bounds.height) , animated: true)
        }
        
    }
    
    
    
}
///MARK: Calendar
extension QuickPayViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        self.date = date
        dateLabel.text = fullDateToString(date: date)
    }
}
