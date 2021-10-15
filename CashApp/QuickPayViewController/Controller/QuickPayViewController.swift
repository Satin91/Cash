//
//  PopUpViewController.swift
//  CashApp
//
//  Created by Артур on 24.12.20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar
import Themer


class QuickPayViewController: UIViewController, UIScrollViewDelegate{
    
    var tableView = QuickTableView()
    let colors = AppColors()
    var reloadParentTableViewDelegate: ReloadParentTableView!
    let notifications = Notifications() // Так как после оплаты плана база может измениться, этот экземпляр
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var okButtonOutlet: UIButton!
    @IBOutlet var cancelButtomOutlet: UIButton!
    let theme = ThemeManager2.currentTheme()
    let saveCategory = SaveCategory()
    var navigationButtons: NavigationButtons!
    var blurHeader = UIVisualEffectView(effect: UIBlurEffect(style: Themer.shared.theme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark))
    let returnToCenter = ReturnToCenterOfScrollView()
    var payObjectNameLabel: TitleLabel = {
        var label = TitleLabel()
        label.text = "ObjectNameError"
        label.font = .systemFont(ofSize: 34,weight: .bold)
        label.textAlignment = .left
        return label
    }()
    var accountLabel: SubTitleLabel = {
        var label = SubTitleLabel()
        label.text = "AccountNameError"
        label.font = .systemFont(ofSize: 17,weight: .regular)
        return label
    }()
    var dateLabel: SubTitleLabel = {
        var label = SubTitleLabel()
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
        object.currencyISO = mainCurrency?.ISO ?? "USD"
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
        sumTextField.textFieldChanged()
        
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
  
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setColors()
        calendar = FSCalendarView(frame: self.view.bounds, calendarType: .mini)
        self.isModalInPresentation = true
        calendar.delegate = self
        setupSumTextField()
        setupContainerView()
        setupTableView()
        setupScrollView()
        setupCancelButton()
        checkPayObjectAndSetItsValue()
        setupNavigationsButtons()
        createConstraints()
    }
    
//    func setupNavBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = UIColor.clear
//        appearance.backgroundEffect = UIBlurEffect(style: Themer.shared.theme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark) // or dark
//        let scrollingAppearance = UINavigationBarAppearance()
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//    }
//
    deinit {
        print("deinit QuickPayNavigationButtons")
    }
    func setupNavigationsButtons() {
        navigationButtons = NavigationButtons(parentView: blurHeader.contentView)
        navigationButtons.didTapped {
            self.returnToCenter.returnToCenter(scrollView: self.scrollView)
        }
    }
    func setupScrollView() {
        scrollView.contentSize = CGSize(width: 1200, height: 0)
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.addSubview(tableView)
        scrollView.addSubview(calendar)
        scrollView.addSubview(containerView)
        scrollView.addSubview(numpadView.view)
        scrollView.addSubview(blurHeader)
        
    }
    func setupTableView() {
        tableView = QuickTableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setupCancelButton() {
        self.cancelButton = CancelButton(frame: .zero, title: .cancel, owner: self)
        cancelButton.addToScrollView(view: self.scrollView)
        cancelButton.backgroundColor = .clear
        cancelButton.contentHorizontalAlignment = .right
    }
    func setupContainerView(){
        numpadView.delegateAction = self
        containerView.addSubview(convertedSumLabel)
        containerView.addSubview(payObjectNameLabel)
        containerView.addSubview(sumTextField)
        containerView.addSubview(accountLabel)
        containerView.addSubview(dateLabel)
    }
    func setupSumTextField() {
        sumTextField.isEnabled = true
        sumTextField.tintColor = .clear
        sumTextField.becomeFirstResponder()
        sumTextField.inputView = UIView()
        sumTextField.inputAccessoryView = UIView()
        
        sumTextField.addTarget(self, action: #selector(didTappedTextField(_:)), for: .touchDown)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.sumTextField)
            print(position)
        }
    }
    
    @objc func didTappedTextField(_ textField: UITextField) {
        print(#function)
        textField.tintColor = colors.contrastColor1
        //sumTextField.tintColor = colors.contrastColor1
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //cancelButton.frame.origin.x = self.view.bounds.width + 26
        cancelButton.frame.origin.x += self.view.frame.width / 2
        let navBarHeight = self.navigationController!.navigationBar.frame.height
        let edge: CGFloat = 22
        let viewWidth = self.view.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        let tableViewY: CGFloat = 12
      
        tableView.frame = CGRect(x: 0, y: self.view.bounds.origin.y - navBarHeight, width: self.view.bounds.width, height: self.view.frame.height)
        tableView.contentInset = UIEdgeInsets(top: edge / 2 , left: 0, bottom: 0, right: 0)
        scrollOffset = self.view.bounds.width
        scrollView.contentSize = CGSize(width: viewWidth * 3, height: 1) // Height 1 для того чтобы нелзя было скролить по вертикали
        self.blurHeader.frame = CGRect(x: 0, y: -navBarHeight, width: viewWidth * 3, height: navBarHeight)
        self.navigationButtons.putOnView(.foward)
        self.navigationButtons.putOnView(.backward)
        containerView.frame = CGRect(x: viewWidth + 26, y: 22, width: viewWidth - 26 * 2, height: scrollViewHeight / 2)
        calendar.frame = CGRect(x: viewWidth * 2 + edge, y: edge, width: self.view.bounds.width - (edge * 2), height: scrollViewHeight - edge * 6)
        calendar.layer.cornerCurve = .continuous
        calendar.layer.cornerRadius = 22
        calendar.layoutSubviews()
        isOffsetUsed = true
        scrollView.contentSize.height = 1 // Disable vertical scroll
       
    }
    
    //MARK: - CHECK VALUE
    func checkPayObjectAndSetItsValue() {
        switch payObject {
        case is MonetaryCategory:
            let object = payObject as! MonetaryCategory
            //self.convertedSumLabel.alpha = 0 // Пришлось скрыть таким образом, чтобы в tableView did select row он опять показывается
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
            if object.secondAccountID != "" {
                selectedAccountObject = findAccount(byID: object.secondAccountID)
            } else {
                if object.accountID == "NO ACCOUNT" {
                    selectedAccountObject = withoutAccountObject
                    accountLabel.text = withoutAccountObject.name
                } else {
                    for i in EnumeratedAccounts(array: accountsGroup) {
                        if i.accountID == object.accountID {
                            selectedAccountObject = i
                        }
                    }
                }
            }
        case is TransferModel:
            selectedAccountObject = withoutAccountObject
        default:
            break
        }
        accountLabel.text = selectedAccountObject != nil ? selectedAccountObject?.name : withoutAccountObject.name
    }
    
    func findAccount(byID: String) -> MonetaryAccount {
        for i in accountsObjects {
            if i.accountID == byID {
                return i
            }
        }
        return withoutAccountObject
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
            monetaryPaymentISO = selectedAccountObject!.currencyISO
            saveHistorySum(vector: object.vector)
            saveCategory(convertedSum: convertedEnteredSum)
            saveCategory.saveHistoryForCategory(selectedAccountObject: selectedAccountObject!,
                                                historyObject: historyObject,
                                                enteredSum: Double(sumTextField.enteredSum)!)
            return
        } else if payObject is PayPerTime {
            let object = payObject as! PayPerTime
            saveHistorySum(vector: object.vector)
            savePayPerTime()
        } else if payObject is MonetaryScheduler {
            let object = payObject as! MonetaryScheduler
            saveHistorySum(vector: object.vector)
            saveScheduler()
            notifications.sendNotifications()
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
        // Если объект редактируется:
        if payObject is AccountsHistory {
            print("payObject is AccountsHistory")
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

}

///MARK: Table view

extension QuickPayViewController:  tappedButtons{
    func scrollAndBackspace(action: String) {
        let x: CGFloat = action == "Accounts" ? 0 : self.view.bounds.width * 2.8
        switch action {
        case "Backspace":
            guard sumTextField.text != "" else {return}
            //  sumTextField.text?.removeLast()
            sumTextField.deleteBackward()
            //textFieldChanged()
            observeConvertedSum()
        case "Save":
            let doubleEnteredSum = Double(sumTextField.enteredSum)
            guard doubleEnteredSum! > 0 else {return}
            save()
            dismiss(animated: true) {
                guard let reload = self.reloadParentTableViewDelegate else { return }
                reload.reloadData()
            }
        default:
            scrollView.scrollRectToVisible(CGRect(x: x, y: 0, width: self.view.bounds.width / 3, height: self.view.bounds.height) , animated: true)
        }
        
    }
    
    
    
}
///MARK: Calendar
extension QuickPayViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        returnToCenter.returnToCenterWithDelay(scrollView: self.scrollView)
        self.date = date
        dateLabel.text = dateToString(date: date)
    }
}
