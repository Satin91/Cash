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
    let colors = AppColors()
    var reloadParentTableViewDelegate: ReloadParentTableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var okButtonOutlet: UIButton!
    @IBOutlet var cancelButtomOutlet: UIButton!
    let theme = ThemeManager2.currentTheme()
    var payObjectNameLabel: TitleLabel = {
        var label = TitleLabel()
        label.text = "ObjectNameError"
        label.font = .systemFont(ofSize: 26,weight: .regular)
        return label
    }()
    var accountLabel: TitleLabel = {
        var label = TitleLabel()
        label.text = "AccountNameError"
        label.font = .systemFont(ofSize: 17,weight: .regular)
        return label
    }()
    var dateLabel: TitleLabel = {
        var label = TitleLabel()
        label.text = NSLocalizedString("day_is_today", comment: "")
        label.font = .systemFont(ofSize: 17,weight: .regular)
        return label
    }()
    var convertedSumLabel: SubTitleLabel = {
        let label = SubTitleLabel()
        label.text = ""
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 26, weight: .regular)
        return label
    }()
    var sumTextField: NumberTextField = {
        let tf = NumberTextField()
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.textAlignment = .right
        tf.addTarget(self, action: #selector(observeConvertedSum), for: .editingChanged)
        tf.font = .systemFont(ofSize: 54, weight: .regular)
        tf.minimumFontSize = 26
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()
    let transfer = Transfer()
    var numpadView = NumpadView()

    var calendar: FSCalendarView!
    var date = Date()
    //Аккаунт для того чтобы поставить его первым
    var withoutAccountObject: MonetaryAccount = {
        var object = MonetaryAccount()
        object.name = NSLocalizedString("without_Account", comment: "")
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
    var changeHistoryObject: ChangeHistoryObject!
    var payObject: Any! {
        willSet{
            switch newValue {
            case is TransferModel:
                let object = newValue as! TransferModel
                monetaryPaymentISO = object.account.currencyISO
            case is MonetaryCategory:
                let object = newValue as! MonetaryCategory
                monetaryPaymentISO = object.currencyISO
            case is MonetaryScheduler:
                let object = newValue as! MonetaryScheduler
                monetaryPaymentISO = object.currencyISO
            case is PayPerTime:
                let object = newValue as! PayPerTime
                monetaryPaymentISO = object.currencyISO
            case is AccountsHistory:
                let object = newValue as! AccountsHistory
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
    var cancelButton: CancelButton!
    
    var containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 25
        
        return view
    }()
    var isOffsetUsed = false {
        didSet {
            guard oldValue == false else {return}
            scrollView.contentOffset.x = scrollOffset
        }
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
            guard let convertedSum = currencyModelController.convert(Double(sumTextField.enteredSum), inputCurrency: monetaryPaymentISO, outputCurrency: currencyCarrier) else {return}
            
            self.convertedEnteredSum = convertedSum.removeHundredthsFromEnd()
            convertedSumLabel.text = convertedSum.currencyFormatter(ISO: currencyCarrier)
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
    func createCancelButton() {
        self.cancelButton = CancelButton(frame: .zero, title: .cancel, owner: self)
        cancelButton.addToScrollView(view: self.scrollView)
         
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setColors()
        createCancelButton()
        payObjectNameLabel.textAlignment = .left
        tableView = QuickTableView(frame: .zero)
        calendar = FSCalendarView(frame: self.view.bounds)
        calendar.delegate = self
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        tableView.layer.masksToBounds = false
        tableView.clipsToBounds = false
        sumTextField.isEnabled = false
        setupContainerView()
        setupScrollView()
        checkPayObjectAndSetItsValue()
        
        UIApplication.shared.reloadInputViews()
        
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
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //cancelButton.frame.origin.x = self.view.bounds.width + 26
        cancelButton.frame.origin.x += self.view.frame.width / 2
        let edge: CGFloat = 22
        let viewWidth = self.view.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        tableView.frame = CGRect(x: 0, y: 12, width: self.view.bounds.width, height: self.view.bounds.height)
        
        
        scrollOffset = self.view.bounds.width
        scrollView.contentSize = CGSize(width: viewWidth * 3, height: 1) // Height 1 для того чтобы нелзя было скролить по вертикали
        
        containerView.frame = CGRect(x: viewWidth + 26, y: 22, width: viewWidth - 26 * 2, height: scrollViewHeight / 2)
        calendar.frame = CGRect(x: viewWidth * 2 + edge, y: edge, width: self.view.bounds.width - (edge * 2), height: scrollViewHeight - edge)
        calendar.layer.cornerCurve = .continuous
        calendar.layer.cornerRadius = 22
        isOffsetUsed = true
        scrollView.contentSize.height = 1 // Disable vertical scroll
    }
    
    //MARK: - CHECK VALUE
    func checkPayObjectAndSetItsValue() {
        switch payObject {
        case is MonetaryCategory:
            let object = payObject as! MonetaryCategory
            payObjectNameLabel.text = object.name
        case is MonetaryScheduler:
            let object = payObject as! MonetaryScheduler
            payObjectNameLabel.text = object.name
            if object.stringScheduleType == .oneTime {
                payObjectNameLabel.text = object.name
                sumTextField.text = String(object.target - object.available)
                sumTextField.enteredSum = String(object.target - object.available)
            }
        case is PayPerTime:
            let object = payObject as! PayPerTime
            sumTextField.text = String(object.target.formattedWithSeparator)
            sumTextField.enteredSum = String(object.target)
            payObjectNameLabel.text = object.scheduleName
            
        case is AccountsHistory:
            let object = payObject as! AccountsHistory
            payObjectNameLabel.text = object.name
            monetaryPaymentISO = object.currencyISO
            changeHistoryObject = ChangeHistoryObject(historyObject: object)
            let positiveSum = abs(object.sum)

            sumTextField.text = String(positiveSum.formattedWithSeparator)
            sumTextField.enteredSum = String(positiveSum)
            if  object.accountID == "NO ACCOUNT" {
                selectedAccountObject = withoutAccountObject
                accountLabel.text = withoutAccountObject.name
            } else {
            for i in EnumeratedAccounts(array: accountsGroup) {
                if i.accountID == object.accountID {
                    selectedAccountObject = i
                }
            }
            }
            
        default:
            break
        }
        accountLabel.text = selectedAccountObject != nil ? selectedAccountObject?.name : withoutAccountObject.name
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
        let newNextObject = PayPerTime(scheduleName: scheduleObject.name, date: Calendar.current.date(byAdding: calendarComponent, value: 1, to: object.date)!, dateOfCreation: Date(), target: scheduleObject.sumPerTime, currencyISO: object.currencyISO, scheduleID: scheduleObject.scheduleID, vector: object.vector)
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
        historyObject.convertedSum = vector == true ? convertedEnteredSum : -convertedEnteredSum
        
        
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
    
    //MARK: - Save
    func save() {
        //Настройки по умолчанию для всех типов транзакций
        historyObject.date = self.date
        historyObject.accountID = withoutAccountObject.accountID
        
        if payObject is MonetaryCategory {
            let object = payObject as! MonetaryCategory
            saveHistorySum(vector: object.vector)
            saveCategory(convertedSum: convertedEnteredSum)
        } else if payObject is PayPerTime {
            let object = payObject as! PayPerTime
            saveHistorySum(vector: object.vector)
            savePayPerTime()
        } else if payObject is MonetaryScheduler {
            let object = payObject as! MonetaryScheduler
            saveHistorySum(vector: object.vector)
            saveScheduler()
        } else if payObject is AccountsHistory {
            let object = payObject as! AccountsHistory
           // let enteredSum = Double(sumTextField.enteredSum)!
            let vector: Bool = object.sum > 0 ? true : false
            saveHistorySum(vector: vector)
        } else if payObject is TransferModel {
            let object = payObject as! TransferModel
            let vector = object.transferType == .receive ? true : false
            saveHistorySum(vector: vector)
            
            let cooperatingAccount = selectedAccountObject == nil ? withoutAccountObject : selectedAccountObject!
            transfer.saveTransfer(transferredObject: object, cooperatingAccount: cooperatingAccount, enteredSum: Double(sumTextField.enteredSum)!, historyObject: historyObject, createHistory: true)
            return // Выходит из функции чтобы не идти дальше и не создать объект истории как при оплате планировщика или категории
        }
        
       
        //Если счет выбран
        historyObject.accountID = selectedAccountObject!.accountID
        //historyObject.accountName = selectedAccountObject!.name
        if payObject is AccountsHistory {
            historyObject.currencyISO = selectedAccountObject!.currencyISO
            changeHistoryObject.makeHistoryChanges(newHistoryObject: historyObject)
        } else {
         saveHistory()
        }
    }
    func saveHistory(){
        guard selectedAccountObject?.accountID != "NO ACCOUNT" else{
            DBManager.addHistoryObject(object: historyObject)
            return}
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
    
    func configureBackgroundView(cell: UITableViewCell) {
        
        var backg = UIView(frame: cell.bounds)
        backg.frame = cell.bounds.inset(by: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26) )
        backg.backgroundColor = colors.secondaryBackgroundColor
        backg.layer.cornerRadius = 20
        backg.layer.setSmallShadow(color: colors.shadowColor)
        cell.contentView.addSubview(backg)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textColor = colors.titleTextColor
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        cell.layer.masksToBounds = false
        cell.textLabel?.textAlignment = .center
        
        
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
        //WithoutAccountCell
        if indexPath.row == appendAccount.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WithoutAccountCell", for: indexPath)
            configureBackgroundView(cell: cell)
            cell.textLabel?.text = object.name
            cell.selectionStyle = .none
            //cell.backgroundView!.frame = (cell.backgroundView?.bounds.inset(by: UIEdgeInsets(top: 2, left: 50, bottom: 5, right: 50) ))!
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuickTableViewCell", for: indexPath) as! QuickTableVIewCell
            cell.selectionStyle = .none
        cell.set(object: object)
        return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = privateAccounts()[indexPath.row]
        guard object != privateAccounts().last else {
            selectedAccountObject = withoutAccountObject
            accountLabel.text = selectedAccountObject?.name
            convertedSumLabel.isHidden = true // Скрывает конвертер чтобы не показывал ненужную конвертацию ( по умолчанию у withoutObject стоит ISO USD)
            ReturnToCenterOfScrollView.returnToCenter(scrollView: self.scrollView)
            return}
        
        convertedSumLabel.isHidden = false //Возвращает видение если то было выключено
        selectedAccountObject = object
        accountLabel.text = object.name
        self.observeConvertedSum()
        ReturnToCenterOfScrollView.returnToCenter(scrollView: self.scrollView)
       
        
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
            save()
            dismiss(animated: true) {
                guard let reload = self.reloadParentTableViewDelegate else { return }
                reload.reloadData()
            }

        }else {
        }

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
        ReturnToCenterOfScrollView.returnToCenter(scrollView: self.scrollView)
        self.date = date
        dateLabel.text = dateToString(date: date)
    }
}
