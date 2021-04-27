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
class AddScheduleViewController: UIViewController {
    
    
    var reloadParentTableView: ReloadTableView!
    // @IBOutlet var nameTextField: NumberTextField!
    
    @IBOutlet var headingTextLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var totalSumTextField: NumberTextField!
    @IBOutlet var sumPerTimeTextField: NumberTextField!
    var dateRhythm: DateRhythm = .week
    var payArray = [PayPerTime]() // Используется в записи платежных данных
    @IBOutlet var scrollView: UIScrollView! // Нужен только для отмены скролинга в случае выбора одноразовой операции
    
    
    @IBAction func dateRhythmSegmentedController(_ sender: HBSegmentedControl) {
        switch sender.selectedIndex {
        case 0:
            self.dateRhythm = .week
        case 1:
            self.dateRhythm = .month
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
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var selectDateButtonOutlet: UIButton!
    @IBOutlet var selectImageButtonOutlet: UIButton!
    @IBAction func selectDateButtonAction(_ sender: Any) {
        self.view.animateViewWithBlur(animatedView: blurView, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendar, parentView: self.view)
    }
    @IBOutlet var stackView: UIStackView! //для редактирования расстояния для четчайшести
    @IBOutlet var doneButtonOutlet: UIBarButtonItem!
    @IBAction func doneButtonAction(_ sender: Any) {
        
        guard saveScheduleElement() else {return}
        reloadParentTableView.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var selectedImageName = "card" {
        willSet{
            selectImageButtonOutlet.setImage(UIImage(named: newValue), for: .normal)
            selectImageButtonOutlet.imageView?.contentMode = .scaleToFill
        }
    }
    
    
    ///ПЕРЕМЕННЫЕ
    var date: Date!
    var calendar = FSCalendarView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
    var newScheduleObject = MonetaryScheduler()
    var iconsCollectionView: IconsCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        headingTextLabel.numberOfLines = 0
        segmentedControl.changeValuesForCashApp(segmentOne: "Week", segmentTwo: "Month")
        checkScheduleType()
        setupCalendarAndBlur()
        visualSetup()
        setupNavigationController(Navigation: navigationController!)
        stackViewSettings()
        setupButtonsAndFields()
        isModalInPresentation = true
    }
    
    func setupCalendarAndBlur() {
        self.view.addSubview(calendar)
        calendar.frame = CGRect(x: 50, y: 50, width: 250, height: 320)
        calendar.backgroundColor = .white
        calendar.layer.cornerRadius = 18
        calendar.clipsToBounds = true
        calendar.alpha = 0
        blurView.frame = self.view.bounds
        blurView.alpha = 0
    }
    
    func visualSetup() {
        selectImageButtonOutlet.mainButtonTheme()
        selectImageButtonOutlet.setImage(UIImage(named: selectedImageName), for: .normal)
        
        selectImageButtonOutlet.imageView?.contentMode = .scaleToFill
    }
    func stackViewSettings() {
        if self.view.bounds.height < 600 {
            stackView.spacing = 15
        } else {
            stackView.spacing = 22
        }
    }
    
    func setupButtonsAndFields() {
        //nameTextField.placeholder = "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        totalSumTextField.attributedPlaceholder = NSAttributedString(string: "Total sum", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        sumPerTimeTextField.attributedPlaceholder = NSAttributedString(string: "Sum per time", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
    }
    
    func checkScheduleType() {
        switch newScheduleObject.stringScheduleType{
        case .oneTime :
            headingTextLabel.text = "Add\none time\nschedule"
            sumPerTimeTextField.isHidden = true
            segmentedControl.isHidden = true
            scrollView.isScrollEnabled = false
        case .regular :
            headingTextLabel.text = "Add\nregular\nschedule"
            break
        }
    }

    deinit {
        nameTextField.isHidden = false
        sumPerTimeTextField.isHidden = false
        totalSumTextField.isHidden = false
        scrollView.isScrollEnabled = true
    }
    
    func saveScheduleElement()-> Bool {
        switch newScheduleObject.stringScheduleType {
        case .oneTime:
            
            return saveOneTime()
        case .regular:
            
            return saveRegular()
        }
    }
    
    
   
    
    func savePayPerTime() {
        let targetSum = newScheduleObject.target
        let sumPerTime = newScheduleObject.sumPerTime
        let resultNumbersAndRemainder: (Int, Double?) = getNumberOfMonts(targetSum: targetSum, sumPerTime: sumPerTime)
        if newScheduleObject.stringScheduleType == .regular {
        writeRegularPayPerTime(numberOfMonth: resultNumbersAndRemainder.0, remainingSum: resultNumbersAndRemainder.1)
        }
    }
    
    

    func writeOneTimePayPerTime() {
        let payperTimeObject = PayPerTime()
        payperTimeObject.scheduleName = newScheduleObject.name
        payperTimeObject.date = newScheduleObject.date!
        payperTimeObject.available = 0
        payperTimeObject.scheduleID = newScheduleObject.scheduleID
        payperTimeObject.sumPerTime = newScheduleObject.target
        try! realm.write {
            realm.add(payperTimeObject)
        }
    }
    func writeRegularPayPerTime(numberOfMonth: Int, remainingSum: Double?){
        var iterationDate = date //дата с которой нужно работать в цикле
        let object = newScheduleObject
        var counter = 0 //счетчик
        
        
        
        for _ in 0..<numberOfMonth {
            counter += 1
            if counter == numberOfMonth { // Если итерация послелняя т.е. соответствует количеству месяцев
                if remainingSum != nil {
                    payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, available: 0, sumPerTime: remainingSum!, scheduleID: object.scheduleID))
                }else{
                    payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, available: 0, sumPerTime: object.sumPerTime, scheduleID: object.scheduleID))
                }
            }else{
                payArray.append(PayPerTime(scheduleName: object.name, date: iterationDate!, available: 0, sumPerTime: object.sumPerTime, scheduleID: object.scheduleID))
                let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: iterationDate!)
            iterationDate = nextMonth
            }
            ///Занести payArray в базу
            for i in payArray {
                try! realm.write {
                    realm.add(i)
                }
            }
        }
    }
    func getNumberOfMonts(targetSum: Double, sumPerTime: Double) -> (Int,Double?) {
        let remainderDivision = targetSum.truncatingRemainder(dividingBy: sumPerTime) //remainder division
        let divisionWithoutRemainder = targetSum / sumPerTime //division without remainder
        var numberOfMonth: Int = 0
        if remainderDivision != sumPerTime {
            numberOfMonth = Int(divisionWithoutRemainder.rounded(.up)) // round to up integer(Double)
            return (numberOfMonth,remainderDivision)
        }else{
            numberOfMonth = Int(divisionWithoutRemainder)
            return (numberOfMonth, nil)
        }
    }
    
    func saveOneTime()-> Bool {
        //sumPerTimeTextField.text = "0"
        if nameTextField.text != "", totalSumTextField.text != "", self.date != nil{
            newScheduleObject.name = nameTextField.text!
            newScheduleObject.date = date
            newScheduleObject.target = Double(totalSumTextField.text!)!
            writeOneTimePayPerTime()
            DBManager.addObject(object: newScheduleObject)
            return true
        }else{
            self.showAlert(message: "Заполните все поля")
            return false
        }
    }
    func saveRegular()-> Bool {
        if nameTextField.text != "", totalSumTextField.text != "",sumPerTimeTextField.text != "", date != nil{
            newScheduleObject.name = nameTextField.text!
            newScheduleObject.target = Double(totalSumTextField.text!)!
            newScheduleObject.sumPerTime = Double(sumPerTimeTextField.text!)!
            newScheduleObject.date = date
            newScheduleObject.dateRhythm = dateRhythm.rawValue
            savePayPerTime()
            guard newScheduleObject.target >= newScheduleObject.sumPerTime else {
                self.showAlert(message: "Ошибка", title: "Разовый платежь больше общей суммы :)")
                return false
            }
            DBManager.addObject(object: newScheduleObject)
            return true
        }else{
            self.showAlert(message: "Заполните все поля")
            return false
        }
    }
}

extension AddScheduleViewController: FSCalendarDelegate,FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.date = date
        
        self.view.reservedAnimateView2(animatedView: self.calendar)
        self.view.reservedAnimateView2(animatedView: self.blurView)
        print(date)
    }
}
extension AddScheduleViewController: SendIconToParentViewController {
    func sendIconName(name: String) {
        selectedImageName = name
    }
    
    
}

