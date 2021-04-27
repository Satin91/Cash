//
//  SchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 4.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class SchedulerViewController: UIViewController,dismissVC,ReloadTableView {
    func reloadTableView() {
        tableView.reloadData()
        calendar.reloadData()
        calendar.collectionView.reloadData()
    }
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
  
    
    func dismissVC(goingTo: String, restorationIdentifier: String) {
        let addScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addScheduleVC") as! AddScheduleViewController
        if goingTo == "addScheduleVC" {
            switch restorationIdentifier {
            case "first":
                addScheduleVC.newScheduleObject.stringScheduleType = .oneTime
            case "second":
                addScheduleVC.newScheduleObject.stringScheduleType = .regular
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
        goToPickTypeVC(delegateController: self, buttonsNames: ["One time","Regular"], goingTo: "addScheduleVC")
    }
    
    let datesArray: [Date] = {
        var dates = [Date]()
        for i in payPerTimeObjects{
            dates.append(i.date)
        }
        return dates
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlur()
        createCalendar()
        installTableView()
        calendar.delegate = self
        calendar.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        calendar.reloadData()
        calendar.select(Date(), scrollToDate: true)
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

}


extension SchedulerViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
       // let payPerDateObjects = payPerTimeObjects.filter { $0.date.c }
        let payPerDateObjects: [PayPerTime] = {
            var ppt = [PayPerTime]()
            for i in payPerTimeObjects {
                if date == i.date {
                    ppt.append(i)
                }
            }
            return ppt
        }()
        //persons.filter { $0.hobbies.contains(stringToSearch) }
        
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: monthPosition)
        for i in payPerTimeObjects {
            if date == i.date {
                
                goToSelectDateVC(delegateController: self, payPerTimeObject: payPerDateObjects, sourseView: calendar.cell(for: date, at: monthPosition)!)
                print("Содержит дату, она пренадлежит \(i.scheduleName),Сумма \(i.sumPerTime)")
            }
            
        }
       
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        var datesArray = [Date]()
        for i in payPerTimeObjects {
            datesArray.append(i.date)
        }
        if datesArray.contains(date) {
            return 1
        }else{
            return 0
        }
    }
    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
//        //let object = payPerTimeObjects[position.hashValue]
//        var datesArray = [Date]()
//        for i in payPerTimeObjects {
//            datesArray.append(i.date)
//        }
//
//        if datesArray.contains(date) {
//            cell.contentView.backgroundColor = .systemGray
//            cell.contentView.layer.cornerRadius = 5
//        }
//        return cell
//    }
//    func minimumDate(for calendar: FSCalendar) -> Date {
//
//        return Date()
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        for i in self.datesArray {
            if date == i {
                return .systemGray4
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        for i in self.datesArray {
            if date == i {
                return .systemGray
            }
            }
        return nil
        }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        
//        for i in self.datesArray {
//            if date == i {
//                return 1
//            }
//            }
        return 1
        
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
}

extension SchedulerViewController : UIPopoverPresentationControllerDelegate{

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SchedulerViewController: closeSelectDateProtocol, PopUpProtocol {
    func closePopUpMenu() {
        self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView(animatedView: quickPayVC.view, viewController: nil)
        self.quickPayVC = nil
        tableView.reloadData()
        calendar.collectionView.reloadData()
        calendar.reloadData()
    }
    
    func closeSelectDate(payPerTimeObject: PayPerTime) {
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: payPerTimeObject)
        
        
    }
    
    
}
