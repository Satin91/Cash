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
    }
    
    
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
    
    
    @IBAction func addButton(_ sender: Any) {
        goToPickTypeVC(delegateController: self, buttonsNames: ["One time","Regular"], goingTo: "addScheduleVC")
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func createCalendar(){
        calendarBackground.addSubview(calendar)
        initConstraints(view: calendar, to: calendarBackground)
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
    }
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

}


extension SchedulerViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: monthPosition)
        
        let schedulerGroup2 = EnumeratedSchedulers(object: schedulerGroup)
        for i in schedulerGroup2 {
            if date == i.date {
                goToSelectDateVC(delegateController: self, schedulerObject: i, sourseView: cell.contentView)
                print("Содержит дату, она пренадлежит \(i.name),Сумма \(i.sum)")
            }
            
        }
       
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let schedulerGroup2 = EnumeratedSchedulers(object: schedulerGroup)
        var datesArray = [Date]()
        
        for i in schedulerGroup2 {
            datesArray.append(i.date!)
        }
        if datesArray.contains(date) {
            return 1
        }else{
            return 0
        }
        
        
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        if cell.dateIsToday {
            
        }
        return cell
    }
//    func minimumDate(for calendar: FSCalendar) -> Date {
//
//        return Date()
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let datesArray = EnumeratedSchedulers(object: schedulerGroup)
        for i in datesArray {
            if date == i.date {
            return .systemBlue
            }else{
                return nil
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
