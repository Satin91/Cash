//
//  SchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 4.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class SchedulerViewController: UIViewController,dismissVC,CloseController {
    func reloadData() {
        datesArray = updateDatesArray()
        tableView.reloadData()
        calendar.reloadData()
        calendar.collectionView.reloadData()
        calendar.select(Date(), scrollToDate: true)
    }
    
    @IBOutlet var heightCalendarConstraint: NSLayoutConstraint!
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    func dismissVC(goingTo: String, typeIdentifier: String) {
        let addScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addScheduleVC") as! AddScheduleViewController
        if goingTo == "addScheduleVC" {
            switch typeIdentifier {
            case "One time":
                addScheduleVC.newScheduleObject.stringScheduleType = .oneTime
            case "Multiple":
                addScheduleVC.newScheduleObject.stringScheduleType = .multiply
            case "Regular":
                addScheduleVC.newScheduleObject.stringScheduleType = .regular
            case "Goal":
                addScheduleVC.newScheduleObject.stringScheduleType = .goal
            default:
                return
            }
        }
        addScheduleVC.reloadParentTableView = self
        let navVC = UINavigationController(rootViewController: addScheduleVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
    }
    
    
    @IBOutlet var calendarBackground: UIView!
    @IBOutlet var tableView: UITableView!
    var calendar = FSCalendarView()
    var quickPayVC: UIViewController!
    @IBAction func addButton(_ sender: Any) {
        goToPickTypeVC(delegateController: self, buttonsNames: ["One time","Multiple","Regular","Goal"], goingTo: "addScheduleVC")
    }
    var datesArray = [Date]()
    //Я ее напихал во все обновляющие функции т.к. календарь все время обновляется
    
  
    func updateDatesArray() ->[Date]  {
        let datesArray: [Date] = {
            var dates = [Date]()
            for i in payPerTimeObjects{
                dates.append(i.date)
                
            }
            for x in Array(oneTimeObjects) {
                dates.append(x.date!)
            }
            for y in Array(goalObjects) {
                dates.append(y.date!)
            }
            return dates
        }()
        return datesArray
    }
    
    
    private func uniq<S: Sequence, T: Hashable> (source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]() // возвращаемый массив
        var added = Set<T>() // набор - уникальные значения
        var repeating = [T]()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }else{
                repeating.append(elem)
            }
        }
        return repeating
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBlur()
        createCalendar()
        installTableView()
        calendar.delegate = self
        calendar.dataSource = self
        datesArray = updateDatesArray()
  
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        datesArray = updateDatesArray()
        calendar.reloadData()
        calendar.collectionView.reloadData()
        
        
    }
    func installTableView() {
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MainIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    func addBlur() {
        self.blur.frame = self.view.bounds
        self.blur.alpha = 0
        self.view.addSubview(blur)
    }
    
    func createCalendar(){
        calendarBackground.addSubview(calendar)
        initConstraints(view: calendar, to: calendarBackground)
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
    }
    func createObjectsArray(date: Date) -> [Any] {
        var objectsArray = [Any]()
        for i in payPerTimeObjects{
            if i.date == date {
            objectsArray.append(i)
            }
        }
        for x in Array(oneTimeObjects) {
            if x.date == date {
            objectsArray.append(x)
            }
        }
        for y in Array(goalObjects) {
            if y.date == date{
            objectsArray.append(y)
            }
        }
        return objectsArray
    }
   

}


extension SchedulerViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
        let anyArray = createObjectsArray(date: date) // Воспользовался функцией сверху (тут разовый, регулярный платеж и платеж в раз)
        
        guard !anyArray.isEmpty else {return}
        for i in datesArray {
            if date == i {
                goToSelectDateVC(delegateController: self, payObject: anyArray, sourseView: calendar.cell(for: date, at: monthPosition)!)
            }
            
        }
       
            
    }
   
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let a = uniq(source: datesArray)
        if a.contains(date) {
            return a.count + 1
        }else{
            return 0
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        for i in self.datesArray {
            if date == i {
                return .systemPink
            }
            }
        return nil
        }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        
        
        if datesArray.contains(date) {
            return 0.5
        }
        return 0.5
    
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        for i in self.datesArray {
            if date == i {
            return .white
            }
        }
        return nil
    }
}

extension SchedulerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedSchedulers(object: schedulerGroup).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainIdentifier", for: indexPath) as! MainTableViewCell
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        cell.set(monetaryObject: object)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        let pptObject: PayPerTime? = {
           var pptObjects = [PayPerTime]()
            for i in payPerTimeObjects {
                if i.scheduleID == object.scheduleID{
                    pptObjects.append(i)
                }
            }
            guard pptObjects.first != nil else {return nil}
            return pptObjects.first!
        }()
        
        switch object.stringScheduleType {
        case .goal:
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        case .oneTime:
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        case .multiply:
            guard pptObject != nil else {return}
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: pptObject!)
        case .regular:
            guard pptObject != nil else {return}
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: pptObject!)
        }
    }
}

extension SchedulerViewController : UIPopoverPresentationControllerDelegate{

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SchedulerViewController: closeSelectDateProtocol, PopUpProtocol {
    func closeSelectDate(payObject: Any) {
        guard blur.alpha != 1 else {return}
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: payObject)
        
    }
    
    func closePopUpMenu() {
        self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView(animatedView: quickPayVC.view, viewController: nil)
        self.quickPayVC = nil
        datesArray = updateDatesArray()
        tableView.reloadData()
        calendar.collectionView.reloadData()
        calendar.reloadData()
    }
    

    
    
}
