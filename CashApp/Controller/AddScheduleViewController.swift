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
import Themer

protocol closeScheduler {
    func close()
}
class AddScheduleViewController: UIViewController {
    
   
    var closeDelegate: closeScheduler!
    var reloadParentTableViewDelegate: ReloadParentTableView!
    @IBOutlet var topAnchorConstraint: NSLayoutConstraint!
    // @IBOutlet var nameTextField: NumberTextField!
    @IBOutlet var headingTextLabel: UILabel!
    @IBOutlet var descriptionTextLabel: UILabel!
    @IBOutlet var nameTextField: ThemableTextField!
    @IBOutlet var totalSumTextField: NumberTextField!
    @IBOutlet var sumPerTimeTextField: NumberTextField!
    @IBOutlet var expenceVectorButtonOutlet: UIButton!
    @IBOutlet var incomeVectorButtonOutlet: UIButton!
    @IBOutlet var okButtonOutlet: ContrastButton!
    @IBOutlet var selectDateButtonOutlet: MainButton!
    @IBOutlet var selectImageButtonOutlet: UIButton!
    lazy var titleTextColor:UIColor = .clear
    lazy var borderColor:UIColor = .clear
    lazy var backgroundColor: UIColor = .clear
    lazy var subTitleTextColor: UIColor = .clear
    
    @IBAction func okButtonAction(_ sender: Any) {
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
    @IBAction func expenceVectorAction(_ sender: UIButton) {
        self.vector = false
        expenceVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) { [weak self] in
            self!.incomeVectorButtonOutlet.backgroundColor = self!.borderColor
            self!.expenceVectorButtonOutlet.backgroundColor = self!.titleTextColor
        }
        
    }
    
    @IBAction func incomeVectorAction(_ sender: UIButton) {
        self.vector = true
        incomeVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) { [weak self] in
            self!.expenceVectorButtonOutlet.backgroundColor = self!.borderColor
            self!.incomeVectorButtonOutlet.backgroundColor = self!.titleTextColor
        }
    }
    
    ///ПЕРЕМЕННЫЕ
    var imageForSelectButtonImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "home")
        image.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return image
    }()
    
    var calendarComponent: Calendar.Component = .weekOfMonth
    var date: Date!
    var miniAlertView: MiniAlertView!
    var calendar: FSCalendarView = {
       let calendar = FSCalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
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
    var iconsCollectionView = IconsCollectionView()
    let currencyModelController = CurrencyModelController()
    var alertView = AlertViewController()
    var dateRhythm: DateRhythm = .month
    var dateRhythmArray = [NSLocalizedString("repeat_every_month", comment: ""),NSLocalizedString("repeat_every_week", comment: ""),NSLocalizedString("repeat_every_day", comment: "")]
    var isEditingScheduler: Bool = false
    var vector: Bool = false
    var payArray = [PayPerTime]() // Используется в записи платежных данных
    //var textFieldButton = UIButton(type: .custom)
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
   

    
    @IBAction func selectImageButtonAction(_ sender: Any) {
        
        self.present(iconsCollectionView, animated: true, completion: nil)
        iconsCollectionView.sendImageDelegate = self
    }
 
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
    var selectedImageName = "emptyImage" {
        didSet{
            Themer.shared.register(target: self, action: AddScheduleViewController.theme(_:))
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
        visualSettings()
        Themer.shared.register(target: self, action: AddScheduleViewController.theme(_:))
        self.view.alpha = isEditingScheduler ? 1 : 0
        miniAlertView = MiniAlertView.loadFromNib()
        miniAlertView.controller = self
        checkScheduleType()
        setupCalendarAndTableView()
        stackViewSettings()
        //setupButtonsAndFields()
        
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
            newScheduleObject.dateOfCreation = Date()
            newScheduleObject.image = selectedImageName
            newScheduleObject.currencyISO = currency
            
        }
        
        
        switch newScheduleObject.stringScheduleType {
        case .oneTime:
            return saveOneTime()
        case .multiply:
            return saveMultiply()
        case .regular:
            return saveRegular()
        case .goal :
            return saveGoal()
        }
    }
    
    func getNumberOfMontsForMultyplyPayPerTime(targetSum: Double, sumPerTime: Double) -> (Int,Double?) {
        let remainderDivision = targetSum.truncatingRemainder(dividingBy: sumPerTime) //Деление с остатком
        let divisionWithoutRemainder = targetSum / sumPerTime //Деление без остатка
        var numberOfMonth: Int = 0
        
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
                    payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, dateOfCreation: Date(), target: remainingSum!, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
                }else{
                    payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, dateOfCreation: Date(), target: object.sumPerTime, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
                }
            }else{
                payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, dateOfCreation: Date(), target: object.sumPerTime, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
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
        let resultNumbersAndRemainder: (Int, Double?) = getNumberOfMontsForMultyplyPayPerTime(targetSum: targetSum, sumPerTime: sumPerTime)
        getArrayForMultyplyPayPerTime(numberOfMonth: resultNumbersAndRemainder.0, remainingSum: resultNumbersAndRemainder.1)
    }
    
    func saveRegularPayPerTime() {
        
        if isEditingScheduler == true {
            removeAllPayPerTimeFromScheduler()
        }
        
        let object = newScheduleObject
        var iterationDate = newScheduleObject.date
        for _ in 0..<1 {//создается один объект, который пересоздается
            // payPerTimeObject.date = iterationDate
            payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate, dateOfCreation: Date(), target: object.sumPerTime, currencyISO: object.currencyISO, scheduleID: object.scheduleID, vector: vector))
            let nextMonth = Calendar.current.date(byAdding: calendarComponent, value: 1, to: iterationDate)
            iterationDate = nextMonth!
            
        }
        
            try! realm.write{
                realm.add(payArray)
            
        }
    }

    func saveOneTime()-> Bool {
        
        if nameTextField.text != "", totalSumTextField.text != "", self.date != nil, selectedImageName != "emptyImage"{
            
            name = nameTextField.text!
            target = Double(totalSumTextField.enteredSum)!
            target = totalSumTextField.removeAllExceptNumbers()
    
            if isEditingScheduler {
                
                
                try! realm.write{
                    newScheduleObject.currencyISO = currency
                    newScheduleObject.image = selectedImageName
                    newScheduleObject.name = name
                    newScheduleObject.date = date
                    newScheduleObject.target = target
                    newScheduleObject.vector = self.vector
                    newScheduleObject.dateOfCreation = Date()
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
            
            return miniAlertView.showAlertForScheduler(textFields: [nameTextField,totalSumTextField], imageName: selectedImageName, date: date)
        }
    }
    
   
    
    func saveMultiply()-> Bool {

        if nameTextField.text != "", totalSumTextField.text != "",sumPerTimeTextField.text != "", date != nil, selectedImageName != "emptyImage"{
            
            name = nameTextField.text!
   
            target = totalSumTextField.removeAllExceptNumbers() //
            sumPerTime = sumPerTimeTextField.removeAllExceptNumbers()
            
            guard target >= sumPerTime else {
                
                
                miniAlertView.showMiniAlert(message: "Разовый платежь больше общей суммы", alertStyle: .moreThan)
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
                        newScheduleObject.vector = self.vector
                        newScheduleObject.dateOfCreation = Date()
                        realm.add(newScheduleObject, update: .all)
                    }
                    saveMultiplyPayPerTime()
            }else{
                
            newScheduleObject.name = name
            newScheduleObject.target = target
            newScheduleObject.sumPerTime = sumPerTime
            newScheduleObject.date = date
            newScheduleObject.vector = self.vector
            newScheduleObject.dateRhythm = dateRhythm.rawValue
            
            saveMultiplyPayPerTime()
        
            DBManager.addObject(object: newScheduleObject)
            }
            return true
        }else{
            
            return  miniAlertView.showAlertForScheduler(textFields: [nameTextField,totalSumTextField,sumPerTimeTextField], imageName: selectedImageName, date: date)
            
        }
    }
    
    
    
    func saveRegular() -> Bool {
        if nameTextField.text != "", sumPerTimeTextField.text != "", self.date != nil, selectedImageName != "emptyImage"{
            
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
                        newScheduleObject.dateOfCreation = Date()
                        newScheduleObject.vector = self.vector
                        realm.add(newScheduleObject, update: .all)
                    }

                saveRegularPayPerTime()
                
            }else{
            
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
            
            return miniAlertView.showAlertForScheduler(textFields: [nameTextField,sumPerTimeTextField], imageName: selectedImageName, date: date)
        }
    }
    func saveGoal() -> Bool{
        
        var isOkay = false
        if nameTextField.text != "", totalSumTextField.text != "",sumPerTimeTextField.text != "", self.date != nil, selectedImageName != "emptyImage"{
            name = nameTextField.text!
            target = totalSumTextField.removeAllExceptNumbers()
            sumPerTime = sumPerTimeTextField.removeAllExceptNumbers() // Выполняет роль имеющейся суммы

            
            
            guard target > sumPerTime else {
                
                
                if isEditingScheduler == true {
                    
                self.addAlert(alertView: alertView, title: "Закрыть план?", message: "Имеющаяся сумма равна либо превышает цель", alertStyle: .close)
                    
                    alertView.alertAction = { (success) in
                    
                    if success {
                        isOkay = true

                        self.saveAndCloseScheduler()
                        self.closeAlert(alertView: self.alertView)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.reloadParentTableViewDelegate.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else{
                        self.closeAlert(alertView: self.alertView)
                        isOkay = false
                        
                    }
                }
                }else{
                    miniAlertView.showMiniAlert(message: "Имеющаяся сумма равна либо превышает цель", alertStyle: .moreThan)
                }
                
                
                return isOkay
            }

            if isEditingScheduler {
                try! realm.write {
                    newScheduleObject.currencyISO = currency
                    newScheduleObject.image = selectedImageName
                    newScheduleObject.name = name
                    newScheduleObject.date = date
                    newScheduleObject.available = (sumPerTimeTextField.text!.isEmpty ? 0: sumPerTimeTextField.removeAllExceptNumbers())
                    newScheduleObject.vector = self.vector
                    newScheduleObject.dateOfCreation = Date()
                    newScheduleObject.target = totalSumTextField.removeAllExceptNumbers()
                    realm.add(newScheduleObject,update: .all)
                }
                
            }else{
                newScheduleObject.name = name
                newScheduleObject.date = date
                newScheduleObject.available = (sumPerTimeTextField.text!.isEmpty ? 0: sumPerTimeTextField.removeAllExceptNumbers())
                newScheduleObject.vector = self.vector
                newScheduleObject.target = totalSumTextField.removeAllExceptNumbers()
                DBManager.addObject(object: newScheduleObject)
            }
            
            
            return true
        }else{
          
            
            return miniAlertView.showAlertForScheduler(textFields: [nameTextField,totalSumTextField,sumPerTimeTextField], imageName: selectedImageName, date: date)
                
        }
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
        rightViewTextFieldButtonFor(title: currency)
    }
    
    
    func rightViewTextFieldButtonFor(title: String) {
        if totalSumTextField.isHidden == false  {
            totalSumTextField.createRightButton(text: title)
            totalSumTextField.button.addTarget(self, action: #selector(changeISO(_:)), for: .touchUpInside)
        }else {
            sumPerTimeTextField.createRightButton(text: title)
            sumPerTimeTextField.button.addTarget(self, action: #selector(changeISO(_:)), for: .touchUpInside)
        }
    }
    
    @objc func changeISO(_ sender: UIButton) {
        goToPopUpTableView(delegateController: self, payObject: userCurrencyObjects, sourseView: sender)
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
        case oneTime = "edit_one_time_title"
        case multiply = "edit_multiply_title"
        case regular = "Изменить регулярную оплату"
        case goal = "Изменить существующую цель "
    }
    
    enum descriptionText: String {
        case oneTime = "add_one_time_description"
        case multiply = "add_multiply_description"
        case regular = "add_regular_description"
        case goal = "add_goal_description"
    }
//    enum editingDescriptionText: String {
//        case oneTime = "Изменить разовый платеж"
//        case multiply = "Изменить многоразовый"
//        case regular = "Изменить  регулярную оплату"
//        case goal = "Изменить существующую цель "
//    }
    func checkScheduleType() {
        
        if isEditingScheduler {
            descriptionTextLabel.isHidden = true//Вырубает описание(так как оно бестолковое и так все понятно)
            switch newScheduleObject.stringScheduleType{
            case .oneTime :
                headingTextLabel.text = NSLocalizedString(editingHeaderText.oneTime.rawValue, comment: "")
                sumPerTimeTextField.isHidden = true
                scrollView.isScrollEnabled = true
            case .multiply :
                headingTextLabel.text = NSLocalizedString(editingHeaderText.multiply.rawValue, comment: "")
            case .regular :
                headingTextLabel.text = NSLocalizedString(editingHeaderText.regular.rawValue, comment: "")
                totalSumTextField.isHidden = true
            case .goal :
                headingTextLabel.text = NSLocalizedString(editingHeaderText.goal.rawValue, comment: "")
                sumPerTimeTextField.isHidden = false
            }
        }else{
            descriptionTextLabel.isHidden = false
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
        
        selectDateButtonOutlet.setTitle(dateToString(date: date), for: .normal)
        //selectDateButtonOutlet.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
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
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dateRhythmArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateRhythmCell", for: indexPath)
       // let separatorView = createLineView(cell: cell)
        let separator = SeparatorView(cell: cell).createLineView()
        
        if indexPath.row != dateRhythmArray.count - 1 {
            cell.addSubview(separator)
        }
        
        if indexPath.row == dateRhythm.rawValue - 1 {
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        }else{
            cell.textLabel?.font = .systemFont(ofSize: 17,weight: .regular)
        }
        cell.setColors()
        cell.selectionStyle = .none
        
        
        
        cell.textLabel?.text = object
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dateRhythm = DateRhythm(rawValue: indexPath.row + 1)!
        tableView.reloadData()
    }
}
