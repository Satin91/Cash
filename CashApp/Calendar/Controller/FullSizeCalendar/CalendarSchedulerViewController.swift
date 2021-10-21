//
//  CalendarSchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 26.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
import Themer
extension CalendarSchedulerViewController {
    
    private func theme(_ theme: MyTheme) {
        self.view.backgroundColor = theme.settings.secondaryBackgroundColor
        self.calendarView.backgroundColor = theme.settings.secondaryBackgroundColor
    }
}
class CalendarSchedulerViewController: UIViewController {
    
    @IBOutlet var calendarView: FSCalendarView!
    @IBOutlet var closeButton: UIBarButtonItem!
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var cancelButton: CancelButton!
    var datesArray = [Date]()
    var quickPayVC: UIViewController!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var DIYDatesArray: [DateComponents] = []
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController!.navigationBar.backgroundColor = .clear
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createCancelButton()
        self.calendarView.calendarType = .regular
        calendarView.reloadData()
        calendarView.register(DIYFSCalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        calendarView.delegate = self
        calendarView.dataSource = self
        //calendarView.appearance.headerTitleOffset
        calendarView.layer.cornerRadius = 22
        datesArray = updateDatesArray()
        Themer.shared.register(target: self, action: CalendarSchedulerViewController.theme(_:))
        // Do any additional setup after loading the view.
    }
    
    func updateDatesArray() ->[Date]  {
        let datesArray: [Date] = {
            var dates = [Date]()
            for i in payPerTimeObjects{
                dates.append(i.date)
                
            }
            for x in Array(oneTimeObjects) {
                dates.append(x.date)
            }
            for y in Array(goalObjects) {
                dates.append(y.date)
            }
            return dates
        }()
        return datesArray
    }
    
    func createCancelButton() {
        cancelButton = CancelButton(frame: self.view.bounds, title: .close, owner: self)
        cancelButton.addToParentView(view: self.view)
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

//MARK: CalendarDelegateDataSource / appearance
extension CalendarSchedulerViewController: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance, FSCalendarCollectionViewInternalDelegate{
   
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarCell", for: date, at: position) as! DIYFSCalendarCell
        cell.setStyle(cellStyle: .DIYCalendar)
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
    }
   
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
        let cell = self.calendar(calendar, cellFor: date, at: monthPosition) as! DIYFSCalendarCell
        let anyArray = createObjectsArray(date: date) // Воспользовался функцией сверху (тут разовый, регулярный платеж и платеж в раз)
        guard !anyArray.isEmpty else {return}
        for i in datesArray {
            if date == i {
                goToPopUpTableView(delegateController: self, payObject: anyArray, sourseView: calendar.cell(for: date, at: monthPosition)!, type: .inCalendar)
            }
        }
    }

    
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configureEvent(cell: cell, for: date!, at: position)
            self.configureDIY(cell: cell, for: date!, at: position)
            configureToday(cell: cell, for: date!, at: position)
        }
    }
    private func configureToday(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let cell = (cell as! DIYFSCalendarCell)
        if date.thisDayisToday() {
            cell.backgroundView?.backgroundColor = cell.borderColor
        }
    }
    private func configureEvent(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYFSCalendarCell)
        
        if datesArray.contains(date) {
            diyCell.eventView.isHidden = false
        }else{
            diyCell.eventView.isHidden = true
        }
    }
   
    func setDIYDates(startDate: Date, endDate: Date){
        DIYDatesArray = []
        let dayDurationInSeconds: TimeInterval = 60*60*24
        for date in stride(from: startDate, to: endDate, by: dayDurationInSeconds) {
            let component = Calendar.current.dateComponents([.day,.month,.year], from: date)
            DIYDatesArray.append(component)
        }
    }
    private func configureDIY(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYFSCalendarCell)
        let components = self.gregorian.dateComponents([.day,.month,.year], from: date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            if DIYDatesArray.contains(components) {
                let previousDate: DateComponents = DateComponents(year: components.year, month: components.month, day: components.day! - 1)
                let nextDate: DateComponents = DateComponents(year: components.year, month: components.month, day: components.day! + 1)
                if DIYDatesArray.contains(components) {
                    if DIYDatesArray.contains(previousDate) && DIYDatesArray.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if DIYDatesArray.contains(previousDate) && DIYDatesArray.contains(components) {
                        selectionType = .rightBorder
                    }
                    else if DIYDatesArray.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            // diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }

    
}
extension CalendarSchedulerViewController : UIPopoverPresentationControllerDelegate{


    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
extension CalendarSchedulerViewController: ReloadParentTableView {
    func reloadData() {
        datesArray = updateDatesArray()
        //tableView.reloadData()
        calendarView.collectionView.reloadData()
        calendarView.reloadData()
    }
}
//Закрывает поп ап меню, обновляет данные, закрывает анимацию
extension CalendarSchedulerViewController: ClosePopUpTableViewProtocol{
    
    //close mini table view in calendar
    func closeTableView(object: Any) {
        
        DispatchQueue.main.async {
            self.goToQuickPayVC(reloadDelegate: self, PayObject: object)
        }
        
        //CashApp.goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        
    }
    //close quicl pay and reload data in calendar and hide blur
    func closePopUpMenu() {
        // self.view.reservedAnimateView2(animatedView: blur)
       
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }
}
