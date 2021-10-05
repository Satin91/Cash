//
//  TodayBalanceCalendarViewController.swift
//  CashApp
//
//  Created by Артур on 28.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class TodayBalanceCalendarViewController: UIViewController {

    @IBOutlet var doneButton: ContrastButton!
    @IBOutlet var calendar: FSCalendarView!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var datesArray = [Date]()
    var DIYDatesArray: [DateComponents] = []
    var cancelButton: CancelButton!
    var endDate: Date?
    let colors = AppColors()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors.loadColors()
        
        self.view.backgroundColor = colors.secondaryBackgroundColor
        calendarSettings()
        buttonsSettings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let endDate = endDate else { return }
        self.calendar.select(endDate, scrollToDate: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendar.layoutSubviews()
    }
    func calendarSettings() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.calendarType = .regular
        
        calendar.register(DIYFSCalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        
    }
    func buttonsSettings() {
        cancelButton = CancelButton(frame: .zero, title: .cancel, owner: self)
        cancelButton.addToParentView(view: self.view)
        doneButton.mainButtonTheme("save_button")
    }
 // Выход назначен в сториборде
    @IBAction func doneButtonAction(_ sender: UIButton) {
        guard let endDate = self.endDate else {return}
        try! realm.write({
            guard todayBalanceObject != nil else {
                let todayBalance = TodayBalance(commonBalance: 0, currentBalance: 0, endDate: endDate)
                realm.add(todayBalance)
                return
            }
            todayBalanceObject?.endDate = endDate
            realm.add(todayBalanceObject!,update: .all)
        })
        
    }
  
    
//
//
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//    }
}
extension TodayBalanceCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
//        return monthPosition == .current
//    }
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        return monthPosition == .current
//    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarCell", for: date, at: position) as! DIYFSCalendarCell
        if date == endDate {
            cell.endDateReserveAnimations()
        }
        cell.setStyle(cellStyle: .DIYCalendar)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
        guard let endDate = self.endDate else { return }
        if date == endDate {
            let cell = self.calendar(calendar, cellFor: date, at: monthPosition) as! DIYFSCalendarCell
            cell.endDateReserveAnimations()
            
        }
        //setDIYDates(startDate: Date(), endDate: endDate)
        
    }
    

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setDIYDates(startDate: Date(), endDate: date)
        self.endDate = date
        configureVisibleCells()
        let anyArray = createObjectsArray(date: date) // Воспользовался функцией сверху (тут разовый, регулярный платеж и платеж в раз)
       
        guard !anyArray.isEmpty else {return}
        for i in datesArray {
            if date == i {
                goToPopUpTableView(delegateController: self, payObject: anyArray, sourseView: calendar.cell(for: date, at: monthPosition)!, type: .inCalendar)
            }
            
        }
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
         //   self.configureDIY(cell: cell, for: date!, at: position)
            self.configureEvent(cell: cell, for: date!, at: position)
            configureToday(cell: cell, for: date!, at: position)
        }
        
    }
    
    //MARK: - Deprecated now
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
    private func setDIYDates(startDate: Date, endDate: Date){
        DIYDatesArray = []
        let dayDurationInSeconds: TimeInterval = 60*60*24
        let component = Calendar.current.dateComponents([.day,.month,.year], from: endDate)
        let endDateOneUP = DateComponents(year: component.year, month: component.month,day: component.day! + 1) // Пришлось увеличить на 1 день потому что не рассчитывает с условием "Включительно"
        let newEndDate = Calendar.current.date(from: endDateOneUP)
        for date in stride(from: startDate, to: newEndDate!, by: dayDurationInSeconds) {
            let component = Calendar.current.dateComponents([.day,.month,.year], from: date)
            DIYDatesArray.append(component)
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
    
    private func configureToday(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let cell = (cell as! DIYFSCalendarCell)
        if date.thisDayisToday() {
            cell.backgroundView?.backgroundColor = colors.contrastColor1
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

extension TodayBalanceCalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
}
