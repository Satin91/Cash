//
//  AddScheduleViewController.swift
//  CashApp
//
//  Created by Артур on 8.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//
import FSCalendar
import UIKit
import RealmSwift
protocol closeScheduler {
    func close()
}
class AddScheduleViewController: UIViewController {
    
    var closeDelegate: closeScheduler!
    var reloadParentTableViewDelegate: ReloadParentTableView!
    @IBOutlet var topAnchorConstraint: NSLayoutConstraint!
    // @IBOutlet var nameTextField: NumberTextField!
    
    @IBOutlet var expenceVectorButtonOutlet: UIButton!
    @IBOutlet var incomeVectorButtonOutlet: UIButton!
    
    
    
    @IBAction func expenceVectorAction(_ sender: UIButton) {
        self.vector = false
        expenceVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) {
            self.incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
            self.expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
        }
        
    }
    
    @IBAction func incomeVectorAction(_ sender: UIButton) {
        self.vector = true
        incomeVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) {
            self.expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
            self.incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
        }
    }
    @IBOutlet var headingTextLabel: UILabel!
    @IBOutlet var descriptionTextLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var totalSumTextField: NumberTextField!
    @IBOutlet var sumPerTimeTextField: NumberTextField!
    ///ПЕРЕМЕННЫЕ
    var calendarComponent: Calendar.Component = .weekOfMonth
    var date: Date!
    var calendar: FSCalendarView = {
       let calendar = FSCalendarView()
        calendar.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        calendar.layer.cornerRadius = 18
        calendar.alpha = 0
        return calendar
    }()
    var tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.alpha = 0
        tableView.layer.cornerRadius = 18
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var newScheduleObject = MonetaryScheduler()
    var iconsCollectionView: IconsCollectionView!
    let currencyModelController = CurrencyModelController()
    var alertView = AlertViewController()
    var dateRhythm: DateRhythm = .month
    var dateRhythmArray = ["Repeat every month","repeat every week","repeat every day"]
    var isEditingScheduler: Bool = false
    var vector: Bool = false
    var payArray = [PayPerTime]() // Используется в записи платежных данных
    var textFieldButton = UIButton(type: .custom)
    var currency: String = {
        let currency: String
        if mainCurrency != nil {
            currency = mainCurrency!.ISO
        }else{
            currency = "USD"
        }
        return currency
    }()
    @IBOutlet var scrollView: UIScrollView! // Нужен только для отмены скролинга в случае выбора одноразовой операции
    @IBAction func dateRhythmSegmentedController(_ sender: HBSegmentedControl) {
        switch sender.selectedIndex {
        case 0:
            self.dateRhythm = .week
            self.calendarComponent = .weekOfMonth
        case 1:
            self.dateRhythm = .month
            self.calendarComponent = .month
        default:
            break
        }
    }

    
    @IBAction func selectImageButtonAction(_ sender: Any) {
        iconsCollectionView = IconsCollectionView(frame: self.view.bounds)
        iconsCollectionView.sendImageDelegate = self
        self.view.addSubview(iconsCollectionView)
        view.animateViewWithBlur(animatedView: iconsCollectionView, parentView: self.view)
    }
    //@IBOutlet var vectorSegmentedControl: HBSegmentedControl!
    // @IBOutlet var rhythmSegmentedControl: HBSegmentedControl!
    @IBOutlet var selectDateButtonOutlet: UIButton!
    @IBOutlet var selectImageButtonOutlet: UIButton!
    @IBAction func selectDateButtonAction(_ sender: Any) {
        self.view.animateViewWithBlur(animatedView: blurView, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendar, parentView: self.view)
        calendar.select(date, scrollToDate: true)
        guard newScheduleObject.stringScheduleType == .multiply || newScheduleObject.stringScheduleType == .regular else {return}
        self.view.animateViewWithBlur(animatedView: tableView, parentView: self.view)
        
    }
    @IBOutlet var stackView: UIStackView! //для редактирования расстояния для четчайшести
    
    @IBOutlet var doneButtonOutlet: UIBarButtonItem!
    @IBAction func doneButtonAction(_ sender: Any) {
        guard saveScheduleElement() else {return}
        dismiss(animated: true, completion: nil )
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var selectedImageName = "AppIcon" {
        willSet{
            selectImageButtonOutlet.setImage(UIImage(named: newValue), for: .normal)
            selectImageButtonOutlet.imageView?.contentMode = .scaleToFill
        }
    }

    

 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = isEditingScheduler ? 1 : 0
        createNavBar()
        
        visualSettings()
        checkScheduleType()
        setupCalendarAndTableView()
        stackViewSettings()
        setupButtonsAndFields()
        isModalInPresentation = true
        guard isEditingScheduler else {return}
        setDataFromEditableObject()
    }
    
 
    
    
    func stackViewSettings() {
        if self.view.bounds.height < 600 {
            stackView.spacing = 15
        } else {
            stackView.spacing = 22
        }
    }

    deinit {
        nameTextField.isHidden = false
        sumPerTimeTextField.isHidden = false
        totalSumTextField.isHidden = false
        scrollView.isScrollEnabled = true
        
    }
    
    func saveScheduleElement()-> Bool {
        
        if isEditingScheduler == false {
            newScheduleObject.image = selectedImageName
            newScheduleObject.currencyISO = currency
        }
        
        
        switch newScheduleObject.stringScheduleType {
        case .oneTime:
            return saveOneTime()
        case .multiply:
            return saveMultiply()
        case .regular:
            print("newScheduleElement")
            return saveRegular()
        case .goal :
            //print(saveGoal())
            return saveGoal()
        }
    }
    func checkEnteredData() -> Bool {
        var message = ""
        guard nameTextField.text != "", totalSumTextField.text != "",sumPerTimeTextField.text != "", date != nil else {
            message = "Заполните все поля"
            self.showMiniAlert(message: message, alertStyle: .warning)
            return false
        }

        return false
    }
    
    func getNumberOfMontsForMultyplyPayPerTime(targetSum: Double, sumPerTime: Double) -> (Int,Double?) {
        let remainderDivision = targetSum.truncatingRemainder(dividingBy: sumPerTime) //Деление с остатком
        let divisionWithoutRemainder = targetSum / sumPerTime //Деление без остатка
        var numberOfMonth: Int = 0
        print(divisionWithoutRemainder.rounded(.up))
        if remainderDivision != sumPerTime && remainderDivision != 0 { //Важно установить дополнительное условие, ведь при делении без остатка возвращается 0. а 0 всегда не sum per time
            numberOfMonth = Int(divisionWithoutRemainder.rounded(.up)) // round to up integer(Double)
            return (numberOfMonth,remainderDivision)
        }else{
            numberOfMonth = Int(divisionWithoutRemainder)
            return (numberOfMonth, nil)
        }
    }
    func getArrayForMultyplyPayPerTime(numberOfMonth: Int, remainingSum: Double?){
        var iterationDate = date //дата с которой нужно работать в цикле
        let object = newScheduleObject
        var counter = 0 //счетчик
        for _ in 0..<numberOfMonth {
            counter += 1
            if counter == numberOfMonth { // Если итерация послелняя т.е. соответствует количеству месяцев
                if remainingSum != nil {
                    payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, target: remainingSum!, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
                }else{
                    payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, target: object.sumPerTime, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
                }
            }else{
                payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, target: object.sumPerTime, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
                let nextMonth = Calendar.current.date(byAdding: calendarComponent, value: 1, to: iterationDate!)
                iterationDate = nextMonth
            }
            ///Занести payArray в базу
            try! realm.write {
                realm.add(payArray)
            }
            
        }
    }
    var name = ""
    var target: Double = 0
    var sumPerTime: Double = 0
    
    func saveMultiplyPayPerTime() {

        if isEditingScheduler == true {
            removeAllPayPerTimeFromScheduler()
        }
        
        let targetSum = target
        let sumPerTime = sumPerTime
        print(targetSum,sumPerTime)
        let resultNumbersAndRemainder: (Int, Double?) = getNumberOfMontsForMultyplyPayPerTime(targetSum: targetSum, sumPerTime: sumPerTime)
        getArrayForMultyplyPayPerTime(numberOfMonth: resultNumbersAndRemainder.0, remainingSum: resultNumbersAndRemainder.1)
    }
    
    func saveRegularPayPerTime() {
        
        if isEditingScheduler == true {
            removeAllPayPerTimeFromScheduler()
        }
        
        let object = newScheduleObject
        var iterationDate = newScheduleObject.date!
        for _ in 0..<1 {//создается один объект, который пересоздается
            // payPerTimeObject.date = iterationDate
            payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate, target: object.sumPerTime, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
            let nextMonth = Calendar.current.date(byAdding: calendarComponent, value: 1, to: iterationDate)
            iterationDate = nextMonth!
            
        }
        
            try! realm.write{
                realm.add(payArray)
            
        }
    }
    
    
    
    
    
    func saveOneTime()-> Bool {
        
        if nameTextField.text != "", totalSumTextField.text != "", self.date != nil{
            
            name = nameTextField.text!
            target = totalSumTextField.removeAllExceptNumbers() //
    
            if isEditingScheduler {
                
                
                try! realm.write{
                    newScheduleObject.currencyISO = currency
                    newScheduleObject.image = selectedImageName
                    newScheduleObject.name = name
                    newScheduleObject.date = date
                    newScheduleObject.target = target
                    newScheduleObject.vector = self.vector
                    realm.add(newScheduleObject,update: .all)
                }
            }else{
                
                newScheduleObject.name = name
                newScheduleObject.date = date
                newScheduleObject.target = target
                newScheduleObject.vector = self.vector
                DBManager.addObject(object: newScheduleObject)
            }

            return true
        }else{
            
            return checkEnteredData()
        }
    }
    
   
    
    func saveMultiply()-> Bool {

        if nameTextField.text != "", totalSumTextField.text != "",sumPerTimeTextField.text != "", date != nil{
            
            name = nameTextField.text!
            target = totalSumTextField.removeAllExceptNumbers() //
            sumPerTime = sumPerTimeTextField.removeAllExceptNumbers()
            
            guard target >= sumPerTime else {
                
                
                self.showMiniAlert(message: "Разовый платежь больше общей суммы", alertStyle: .warning)
                return false
            }
            if isEditingScheduler == true {
                  
                    try! realm.write {
                        newScheduleObject.currencyISO = currency
                        newScheduleObject.image = selectedImageName
                        newScheduleObject.name = name
                        newScheduleObject.target = target
                        newScheduleObject.sumPerTime = sumPerTime
                        newScheduleObject.date = date
                        newScheduleObject.dateRhythm = dateRhythm.rawValue
                        newScheduleObject.vector = vector
                        realm.add(newScheduleObject, update: .all)
                    }

                    saveMultiplyPayPerTime()
                
            }else{
            newScheduleObject.name = name
            newScheduleObject.target = target
            newScheduleObject.sumPerTime = sumPerTime
            newScheduleObject.date = date
            newScheduleObject.dateRhythm = dateRhythm.rawValue
            
            saveMultiplyPayPerTime()
            
           
            DBManager.addObject(object: newScheduleObject)
            }
            return true
        }else{
            
            return  checkEnteredData()
            
        }
    }
    
    
    
    func saveRegular() -> Bool {
        if nameTextField.text != "", sumPerTimeTextField.text != "", self.date != nil{
            
            name = nameTextField.text!
            sumPerTime = sumPerTimeTextField.removeAllExceptNumbers()
            
            
            if isEditingScheduler == true {
                  
                    try! realm.write {
                        newScheduleObject.currencyISO = currency
                        newScheduleObject.image = selectedImageName
                        newScheduleObject.name = name
                        newScheduleObject.sumPerTime = sumPerTime
                        newScheduleObject.date = date
                        newScheduleObject.dateRhythm = dateRhythm.rawValue
                        newScheduleObject.vector = vector
                        realm.add(newScheduleObject, update: .all)
                    }

                saveRegularPayPerTime()
                
            }else{
            print("CreateRegular")
            newScheduleObject.name = name
            newScheduleObject.date = self.date
            newScheduleObject.sumPerTime = sumPerTime
            newScheduleObject.dateRhythm = self.dateRhythm.rawValue
            newScheduleObject.vector = self.vector
            saveRegularPayPerTime()
            DBManager.addObject(object: newScheduleObject)
            }
            return true
        }else{
            
            return checkEnteredData()
        }
    }
    func saveGoal() -> Bool{
        
        var isOkay = false
        if nameTextField.text != "", totalSumTextField.text != "",sumPerTimeTextField.text != "", self.date != nil{
            name = nameTextField.text!
            target = totalSumTextField.removeAllExceptNumbers()
            sumPerTime = sumPerTimeTextField.removeAllExceptNumbers()
            
            guard target > sumPerTime else {
                print("else in save goal")
                
                if isEditingScheduler == true {
                    
                self.addAlert(alertView: alertView, title: "Закрыть план?", message: "Имеющаяся сумма равна либо превышает цель", alertStyle: .close)
                    print("До этапа")
                    alertView.alertAction = { (success) in
                    print("return первый этап")
                    if success {
                        isOkay = true

                        self.saveAndCloseScheduler()
                        self.closeAlert(alertView: self.alertView)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.reloadParentTableViewDelegate.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                        print("return второй этап")
                    }else{
                        self.closeAlert(alertView: self.alertView)
                        isOkay = false
                        print("return else второй этап")
                    }
                }
                }else{
                     self.showMiniAlert(message: "Имеющаяся сумма равна либо превышает цель", alertStyle: .warning)
                }
                
                print("return последний этап")
                
                return isOkay
            }

            if isEditingScheduler {
                try! realm.write {
                    newScheduleObject.currencyISO = currency
                    newScheduleObject.image = selectedImageName
                    newScheduleObject.name = name
                    newScheduleObject.date = date
                    newScheduleObject.available = (sumPerTimeTextField.text!.isEmpty ? 0: sumPerTimeTextField.removeAllExceptNumbers())
                    newScheduleObject.vector = vector
                    newScheduleObject.target = totalSumTextField.removeAllExceptNumbers()
                    realm.add(newScheduleObject,update: .all)
                }
                
            }else{
                newScheduleObject.name = name
                newScheduleObject.date = date
                newScheduleObject.available = (sumPerTimeTextField.text!.isEmpty ? 0: sumPerTimeTextField.removeAllExceptNumbers())
                newScheduleObject.vector = vector
                newScheduleObject.target = totalSumTextField.removeAllExceptNumbers()
                DBManager.addObject(object: newScheduleObject)
            }
            
            
            return true
        }else{
          
            
            return checkEnteredData()
        }
    }
}

//MARK: - visual settings
extension AddScheduleViewController {
    func visualSettings() {
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.headingTextLabel.textColor = ThemeManager.currentTheme().titleTextColor
        self.headingTextLabel.numberOfLines = 2
        self.headingTextLabel.minimumScaleFactor = 0.5
        
        self.descriptionTextLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        self.headingTextLabel.font = .systemFont(ofSize: 34, weight: .medium)
        self.descriptionTextLabel.font = .systemFont(ofSize: 17, weight: .light)
        
        descriptionTextLabel.numberOfLines = 0
        
        incomeVectorButtonOutlet.setTitleColor(ThemeManager.currentTheme().borderColor, for: .normal)
        expenceVectorButtonOutlet.setTitleColor(ThemeManager.currentTheme().borderColor, for: .normal)
        incomeVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().borderColor
        expenceVectorButtonOutlet.backgroundColor = ThemeManager.currentTheme().titleTextColor
        incomeVectorButtonOutlet.layer.cornerRadius = 10
        expenceVectorButtonOutlet.layer.cornerRadius = 10
        
        
        
        selectDateButtonOutlet.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)   //setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        selectDateButtonOutlet.layer.cornerRadius = 16
        selectDateButtonOutlet.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        selectDateButtonOutlet.layer.cornerCurve = .continuous
        selectDateButtonOutlet.titleEdgeInsets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 0)
        selectDateButtonOutlet.contentHorizontalAlignment = .left
        selectDateButtonOutlet.setTitle(NSLocalizedString("date_button", comment: ""), for: .normal)
        newScheduleObject.date == nil ? selectDateButtonOutlet.setTitleColor(ThemeManager.currentTheme().subtitleTextColor, for: .normal) :  selectDateButtonOutlet.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
       
        selectDateButtonOutlet.titleLabel?.textColor = UIColor.black
        selectDateButtonOutlet.layer.borderWidth = 1
        selectDateButtonOutlet.layer.borderColor = ThemeManager.currentTheme().borderColor.cgColor
        
        
        selectImageButtonOutlet.layer.cornerRadius = 25
        selectImageButtonOutlet.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        selectImageButtonOutlet.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)   //setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        selectImageButtonOutlet.setImage(UIImage(named: selectedImageName), for: .normal)
        selectImageButtonOutlet.imageView?.contentMode = .scaleAspectFill
        
        scrollView.backgroundColor = .clear
    }
    func setupButtonsAndFields() {
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().subtitleTextColor ])
        
        let sumPerTimeText = newScheduleObject.stringScheduleType == .goal ? NSLocalizedString("available_sum", comment: "") : NSLocalizedString("sum_per_time_text_field", comment: "")
        totalSumTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("total_sum_text_field", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().subtitleTextColor ])
        sumPerTimeTextField.attributedPlaceholder = NSAttributedString(string: sumPerTimeText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().subtitleTextColor])
        
        nameTextField.changeVisualDesigh()
        totalSumTextField.changeVisualDesigh()
        rightViewTextFieldButtonFor(textField: totalSumTextField)
        sumPerTimeTextField.changeVisualDesigh()
    }
    func constraintsForTableViewAndCalendar() {
        self.view.addSubview(calendar)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 26),
            calendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26),
            calendar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 26),
            //
            tableView.heightAnchor.constraint(equalToConstant: 60 * 3),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -26),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 26),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26),
        ])
        if newScheduleObject.stringScheduleType == .multiply || newScheduleObject.stringScheduleType == .regular {
            
            calendar.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -26).isActive = true
           
        }else{
            calendar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -26).isActive = true
        }
        
    }
    
    func setupCalendarAndTableView() {
        constraintsForTableViewAndCalendar()
        
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateRhythmCell")
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        blurView.frame = self.view.bounds
        blurView.alpha = 0
    }
}

//MARK: - create Controls
extension AddScheduleViewController: ClosePopUpTableViewProtocol{
    func closeTableView(object: Any) {
        let ISO = object as! CurrencyObject
        currency = ISO.ISO
        textFieldButton.setTitle(ISO.ISO, for: .normal)
    }
    
    
    func rightViewTextFieldButtonFor(textField: UITextField) {
        
        
        textFieldButton.setImage(UIImage(named: "send.png"), for: .normal)
        if isEditingScheduler {
            textFieldButton.setTitle(newScheduleObject.currencyISO, for: .normal)
        }else{
            textFieldButton.setTitle(currency, for: .normal)
        }
        textFieldButton.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        textFieldButton.setTitleColor(ThemeManager.currentTheme().borderColor, for: .normal)
        textFieldButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -17, bottom: 0, right: 0)
        textFieldButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        textFieldButton.frame = CGRect(x: CGFloat(textField.frame.size.width - 40), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        textFieldButton.addTarget(self, action: #selector(changeISO(_:)), for: .touchUpInside)
        textField.rightView = textFieldButton
        textField.rightViewMode = .always
    }
    
    @objc func changeISO(_ sender: UIButton) {
        
        goToPopUpTableView(delegateController: self, payObject: userCurrencyObjects, sourseView: sender)
    }
    
    
    
    @objc func createSchedule(_ sender: UIBarButtonItem) {
        guard saveScheduleElement() else {return}
        if isEditingScheduler == false {
            closeDelegate.close()
            self.removeFromParent()
        }else{
        reloadParentTableViewDelegate.reloadData()
        dismiss(animated: true) {
        }
        }
    }
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        guard isEditingScheduler == false else {
            dismiss(animated: true, completion: nil)
            return
        }
        closeDelegate.close()
        dismiss(animated: true) {
            self.removeFromParent()
        }
    }
    func createNavBar(){
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: topBarHeight + 30))
        topAnchorConstraint.constant = topBarHeight + 12
        let navigationItem = UINavigationItem()
        //let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createSchedule(_:)))
        let leftButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(_:)))
        let rightButton =  UIBarButtonItem(title: "Save", style:   UIBarButtonItem.Style.plain, target: self, action: #selector(self.createSchedule(_:)))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
    }
    
    
}

//MARK: - set data for header labels
extension AddScheduleViewController {
    enum headerText: String {
        
        case oneTime = "add_one_time_title"
        case multiply = "add_multiply_title"
        case regular = "add_regular_title"
        case goal = "add_goal_title"
    }
    enum editingHeaderText: String {
        case oneTime = "Изменить разовый платеж"
        case multiply = "Изменить многоразовый"
        case regular = "Изменить регулярную оплату"
        case goal = "Изменить существующую цель "
    }
    
    enum descriptionText: String {
        case oneTime = "add_one_time_description"
        case multiply = "add_multiply_description"
        case regular = "add_regular_description"
        case goal = "add_goal_description"
    }
    func checkScheduleType() {
        
        if isEditingScheduler {
            switch newScheduleObject.stringScheduleType{
            case .oneTime :
                headingTextLabel.text = editingHeaderText.oneTime.rawValue
                descriptionTextLabel.text = descriptionText.oneTime.rawValue
                sumPerTimeTextField.isHidden = true
                //rhythmSegmentedControl.isHidden = true
                scrollView.isScrollEnabled = true
            case .multiply :
                headingTextLabel.text = editingHeaderText.multiply.rawValue
                descriptionTextLabel.text = descriptionText.multiply.rawValue
            // vectorSegmentedControl.isHidden = true
            case .regular :
                headingTextLabel.text = editingHeaderText.regular.rawValue
                descriptionTextLabel.text = descriptionText.regular.rawValue
                totalSumTextField.isHidden = true
                
            case .goal :
                headingTextLabel.text = editingHeaderText.goal.rawValue
                descriptionTextLabel.text = descriptionText.goal.rawValue
                sumPerTimeTextField.isHidden = false
            }
        }else{
        switch newScheduleObject.stringScheduleType{
        case .oneTime :
            headingTextLabel.text = NSLocalizedString(headerText.oneTime.rawValue, comment: "")
                
            descriptionTextLabel.text = NSLocalizedString(descriptionText.oneTime.rawValue, comment: "")
            sumPerTimeTextField.isHidden = true
            //rhythmSegmentedControl.isHidden = true
            scrollView.isScrollEnabled = true
        case .multiply :
            headingTextLabel.text = NSLocalizedString(headerText.multiply.rawValue, comment: "")
            descriptionTextLabel.text =  NSLocalizedString(descriptionText.multiply.rawValue, comment: "")
        // vectorSegmentedControl.isHidden = true
        case .regular :
            headingTextLabel.text = NSLocalizedString(headerText.regular.rawValue, comment: "")
            descriptionTextLabel.text = NSLocalizedString(descriptionText.regular.rawValue, comment: "")
            totalSumTextField.isHidden = true
            
        case .goal :
            headingTextLabel.text = NSLocalizedString(headerText.goal.rawValue, comment: "")
            descriptionTextLabel.text = NSLocalizedString(descriptionText.goal.rawValue, comment: "")
            sumPerTimeTextField.isHidden = false
        }
        }
    }
}

extension AddScheduleViewController: FSCalendarDelegate,FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.date = date
        
        selectDateButtonOutlet.setTitle(fullDateToString(date: date), for: .normal)
        selectDateButtonOutlet.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        self.view.reservedAnimateView2(animatedView: self.calendar)
        self.view.reservedAnimateView2(animatedView: self.blurView)
        self.view.reservedAnimateView2(animatedView: self.tableView)
    }
}
extension AddScheduleViewController: SendIconToParentViewController {
    func sendIconName(name: String) {
        selectedImageName = name
    }
    
    
}
extension AddScheduleViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension AddScheduleViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateRhythmArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func createLineView(cell: UITableViewCell)->UIView {
        let separatorView = UIView(frame: CGRect(x: 0, y: cell.bounds.height - 4, width: cell.bounds.width, height: 4))
        
        separatorView.backgroundColor = ThemeManager.currentTheme().separatorColor
        
        return separatorView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dateRhythmArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateRhythmCell", for: indexPath)
        let separatorView = createLineView(cell: cell)
        if indexPath.row != dateRhythmArray.count - 1 {
            cell.addSubview(separatorView)
            print(indexPath.row)
        }
        if indexPath.row == dateRhythm.rawValue - 1 {
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        }else{
            cell.textLabel?.font = .systemFont(ofSize: 17,weight: .regular)
        }
        cell.textLabel?.textColor = ThemeManager.currentTheme().titleTextColor
        cell.selectionStyle = .none
        cell.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        cell.textLabel?.text = object
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dateRhythm = DateRhythm(rawValue: indexPath.row + 1)!
        tableView.reloadData()
    }
}
