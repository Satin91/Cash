//
//  AddScheduleViewController.swift
//  CashApp
//
//  Created by Артур on 8.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//
import FSCalendar
import UIKit

class AddScheduleViewController: UIViewController {
    
    
    var reloadParentTableView: ReloadTableView!
    // @IBOutlet var nameTextField: NumberTextField!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var totalSumTextField: NumberTextField!
    @IBOutlet var sumPerTimeTextField: NumberTextField!
    var dateRhythm: DateRhythm = .week
    
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
        view.animateView(animatedView: iconsCollectionView, parentView: self.view)
    }
    @IBOutlet var segmentedControl: HBSegmentedControl!
    @IBOutlet var selectDateButtonOutlet: UIButton!
    @IBOutlet var selectImageButtonOutlet: UIButton!
    @IBAction func selectDateButtonAction(_ sender: Any) {
        self.view.animateView(animatedView: blurView, parentView: self.view)
        self.view.animateView(animatedView: calendar, parentView: self.view)
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
            sumPerTimeTextField.isHidden = true
            segmentedControl.isHidden = true
            scrollView.isScrollEnabled = false
        case .regular :
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
    
    
    
    
    func saveOneTime()-> Bool {
        //sumPerTimeTextField.text = "0"
        if nameTextField.text != "", totalSumTextField.text != "", self.date != nil{
            newScheduleObject.name = nameTextField.text!
            newScheduleObject.sum = Double(totalSumTextField.text!)!
            newScheduleObject.date = date
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
            newScheduleObject.sum = Double(totalSumTextField.text!)!
            newScheduleObject.sumPerTime = Double(sumPerTimeTextField.text!)!
            newScheduleObject.date = date
            newScheduleObject.dateRhythm = dateRhythm.rawValue
            guard newScheduleObject.sum >= newScheduleObject.sumPerTime else {
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

