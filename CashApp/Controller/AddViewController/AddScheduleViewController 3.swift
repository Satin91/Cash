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
    
    @IBOutlet var dateRhythmButton: UIButton!
    var closeDelegate: closeScheduler!
    let colors = AppColors()
    var reloadParentTableViewDelegate: ReloadParentTableView!
    let notifications = Notifications() // Применяется для отправки уведомления после создания / изменения плана
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
    @IBOutlet var selectDateButtonOutlet: SecondaryButton!
    @IBOutlet var selectImageButtonOutlet: UIButton!
    @IBOutlet var containerForSaveButton: UIView!
    
    lazy var titleTextColor:UIColor = .clear
    lazy var borderColor:UIColor = .clear
    lazy var backgroundColor: UIColor = .clear
    lazy var subTitleTextColor: UIColor = .clear
    
    @IBAction func okButtonAction(_ sender: Any) {
        guard saveScheduleElement() else {return}
        notifications.sendNotifications()
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
            guard let self = self else { return }
            self.incomeVectorButtonOutlet.backgroundColor = self.borderColor
            self.expenceVectorButtonOutlet.backgroundColor = self.titleTextColor
        }
    }
    
    @IBAction func incomeVectorAction(_ sender: UIButton) {
        self.vector = true
        incomeVectorButtonOutlet.scaleButtonAnimation()
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let self = self else { return }
            self.expenceVectorButtonOutlet.backgroundColor = self.borderColor
            self.incomeVectorButtonOutlet.backgroundColor = self.titleTextColor
        }
    }
    @IBAction func selectImageButtonAction(_ sender: Any) {
        
        self.present(iconsCollectionView, animated: true, completion: nil)
        iconsCollectionView.sendImageDelegate = self
    }
 
    @IBAction func selectDateButtonAction(_ sender: Any) {
        guard newScheduleObject.stringScheduleType == .multiply || newScheduleObject.stringScheduleType == .regular else {return}
    }
    
    var calendarComponent: Calendar.Component = .weekOfMonth // Нужно для рассчета payPerTime
    var date: Date!
    var miniAlertView: MiniAlertView!
    var newScheduleObject = MonetaryScheduler()
    var iconsCollectionView = IconsViewController()
    let currencyModelController = CurrencyModelController()
    var alertView = AlertViewController()
    var dateRhythm: DateRhythm = .month
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
            self.viewAll()
        }
    }
    func hideAll() {
        for i in self.view.subviews {
            i.alpha = 0
        }
    }
    func viewAll() {
        for i in self.view.subviews {
            i.alpha = 1
        }
    }
    func hidesViewIfNeeded() {
        if self.isEditingScheduler == false {
            self.hideAll()
        }
    }
    var navBarButtons: NavigationBarButtons!
    func createNavBarButtons() {
        navigationItem.hidesBackButton = true
        navBarButtons = NavigationBarButtons(navigationItem: self.navigationItem, leftButton: .none, rightButton: .cancel)
        navBarButtons.setRightButtonAction {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupNavBar() {
        let colors = AppColors()
        colors.loadColors()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        
        appearance.backgroundEffect = UIBlurEffect(style: Themer.shared.theme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark) // or dark
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular),NSAttributedString.Key.foregroundColor: colors.titleTextColor]
        let scrollingAppearance = UINavigationBarAppearance()
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 26 - 12
        paragraphStyle.alignment = .left
        scrollingAppearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 46, weight: .medium), .paragraphStyle: paragraphStyle, .foregroundColor: colors.titleTextColor  ]
        
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = .clear // your view (superview) color
        scrollingAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular),NSAttributedString.Key.foregroundColor: colors.titleTextColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollingAppearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors.loadColors()
        setupDateRhythmButton()
        createNavBarButtons()
        visualSettings()
        setupNavBar()
        Themer.shared.register(target: self, action: AddScheduleViewController.theme(_:))
        hidesViewIfNeeded()
        miniAlertView = MiniAlertView.loadFromNib()
        miniAlertView.controller = self
        checkScheduleType()
        //setupNavigationController(self.navigationController)
        self.isModalInPresentation = true
        
        //scrollView.adjustTheSizeOfThe(view: selectDateButtonOutlet)
        guard isEditingScheduler else {return}
        setDataFromEditableObject()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rightViewTextFieldButtonFor(title: currency )
        scrollViewContentSize()
    }

    
    deinit {
        nameTextField.isHidden = false
        sumPerTimeTextField.isHidden = false
        totalSumTextField.isHidden = false
        scrollView.isScrollEnabled = true
    }
    func setupDateRhythmButton() {
        self.dateRhythmButton.menu = self.dateRhythmMenu()
        self.dateRhythmButton.showsMenuAsPrimaryAction = true
    }
    func scrollViewContentSize() {
        let frame = selectDateButtonOutlet.convert(okButtonOutlet.frame, from: self.scrollView)
        let height = abs(frame.origin.y - 60 - 22)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: height)
    }
    func dateRhythmMenu() -> UIMenu {
        let dayTitle = NSLocalizedString("repeat_every_day", comment: "")
        let weekTitle = NSLocalizedString("repeat_every_week", comment: "")
        let monthTitle = NSLocalizedString("repeat_every_month", comment: "")
        let image = UIImage().getNavigationImage(systemName: "checkmark.circle.fill", pointSize: 80, weight: .regular)
        let dayAction = UIAction(title: dayTitle, image: nil, identifier: nil, discoverabilityTitle: nil, state: .on) { ac in
            self.dateRhythm = .day
            self.calendarComponent = .day
            let _ = self.dateRhythmMenu()
        }
        let weekAction = UIAction(title: weekTitle, image: nil, identifier: nil, discoverabilityTitle: nil) { ac in
            self.dateRhythm = .week
            self.calendarComponent = .weekOfMonth
            let _ = self.dateRhythmMenu()
        }
        let monthAction = UIAction(title: monthTitle, image: nil, identifier: nil, discoverabilityTitle: nil) { _ in
            self.dateRhythm = .month
            self.calendarComponent = .month
            let _ = self.dateRhythmMenu()
        }
        
        
        switch dateRhythm {
        case .month:
            dayAction.state = .off
            weekAction.state = .off
            monthAction.state = .on
        case .week:
            dayAction.state = .off
            weekAction.state = .on
            monthAction.state = .off
        case .day:
            dayAction.state = .on
            weekAction.state = .off
            monthAction.state = .off
        case .none:
            dayAction.state = .off
            weekAction.state = .off
            monthAction.state = .off
        }
        
        let menu = UIMenu(title: "", image: nil, identifier: nil , options: .destructive , children: [dayAction,weekAction,monthAction])
        
        
        self.dateRhythmButton.menu = nil
        self.dateRhythmButton.menu = menu
        return menu
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
    // MARK: - Рассчет месяцев и деление общей суммы на месяца
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toCalendarSch" else { return }
        guard let destination = segue.destination as? ModalCalendarViewController else { return }
        destination.endDate = self.date
    }
    // Метод должен присутствовать даже без действий чтобы календарь мог на него сослаться
    @IBAction func unwindFromCalendar(segue: UIStoryboardSegue) {
        guard let date = date else { return }
        selectDateButtonOutlet.setTitle(dateToString(date: date), for: .normal)
    }
    // Получение массива платежей
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
                // Создание следующей даты (исходя из ритма даты)
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
                    
                    self.alertView.showAlert(title: "Закрыть план?", message: "Имеющаяся сумма равна либо превышает цель", alertStyle: .close)
                    
                    alertView.alertAction = { (success) in
                    
                    if success {
                        isOkay = true

                        self.saveAndCloseScheduler()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.reloadParentTableViewDelegate.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else{
                        
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
        goToPopUpTableView(delegateController: self, payObject: userCurrencyObjects, sourseView: sender, type: .currency)
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
        case regular = "edit_regular_title"
        case goal = "edit_goal_title"
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
                
                self.dateRhythmButton.isHidden = true
            case .multiply :
                headingTextLabel.text = NSLocalizedString(editingHeaderText.multiply.rawValue, comment: "")
            case .regular :
                headingTextLabel.text = NSLocalizedString(editingHeaderText.regular.rawValue, comment: "")
                totalSumTextField.isHidden = true
            case .goal :
                self.dateRhythmButton.isHidden = true
                headingTextLabel.text = NSLocalizedString(editingHeaderText.goal.rawValue, comment: "")
                sumPerTimeTextField.isHidden = false
            }
        }else{
            descriptionTextLabel.isHidden = false
        switch newScheduleObject.stringScheduleType{
        case .oneTime :
            headingTextLabel.text = NSLocalizedString(headerText.oneTime.rawValue, comment: "")
            self.dateRhythmButton.isHidden = true
            descriptionTextLabel.text = NSLocalizedString(descriptionText.oneTime.rawValue, comment: "")
            sumPerTimeTextField.isHidden = true
            //rhythmSegmentedControl.isHidden = true
            
        case .multiply :
            headingTextLabel.text = NSLocalizedString(headerText.multiply.rawValue, comment: "")
            descriptionTextLabel.text =  NSLocalizedString(descriptionText.multiply.rawValue, comment: "")
        // vectorSegmentedControl.isHidden = true
        case .regular :
            headingTextLabel.text = NSLocalizedString(headerText.regular.rawValue, comment: "")
            descriptionTextLabel.text = NSLocalizedString(descriptionText.regular.rawValue, comment: "")
            totalSumTextField.isHidden = true
            
        case .goal :
            self.dateRhythmButton.isHidden = true
            headingTextLabel.text = NSLocalizedString(headerText.goal.rawValue, comment: "")
            descriptionTextLabel.text = NSLocalizedString(descriptionText.goal.rawValue, comment: "")
            sumPerTimeTextField.isHidden = false
        }
        }
    }
}

extension AddScheduleViewController: SendIconToParentViewController {
    func sendIconName(name: String) {
        selectedImageName = name
        selectImageButtonOutlet.setImageView(imageName: name, color: colors.titleTextColor)
    }
    
    
}
extension AddScheduleViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

