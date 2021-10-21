//
//  TodayBalanceCalendarViewController.swift
//  CashApp
//
//  Created by Артур on 28.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class ModalCalendarViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var saveButton: ContrastButton!
    @IBOutlet var calendar: FSCalendarView!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet var cancelButtonOutlet: UIButton!
    var datesArray = [Date]()
    var DIYDatesArray: [DateComponents] = []
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("Tapped")
        dismiss(animated: true)
    }
    var endDate: Date? {
        didSet {
            guard let button = self.saveButton else { return }
            self.setActivityTo(button)
        }
    }
    var cameFromTodayBalance: Bool = false
    let colors = AppColors()
    var diyDatesArray: [Date] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors.loadColors()
        setActivityTo(self.saveButton)
        self.containerView.backgroundColor = colors.secondaryBackgroundColor
        self.containerView.layer.cornerRadius = 22
        self.containerView.layer.cornerCurve = .continuous
        self.view.backgroundColor = .clear
        calendarSettings()
        buttonsSettings()
        guard let endDate = endDate else { return }
        setDIYDates(startDate: Date(), endDate: endDate)
        getDiyArray()
        setupCancelButton()
        datesArray = updateDatesArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let endDate = endDate else { return }
        self.calendar.select(endDate, scrollToDate: true)
        self.calendar.bringSubviewToFront(cancelButtonOutlet)
    }
    func setupCancelButton() {
        let image = UIImage().getNavigationImage(systemName: "xmark", pointSize: 22, weight: .medium)
        self.cancelButtonOutlet.setImage(image, for: .normal)
        self.cancelButtonOutlet.setTitle("", for: .normal)
        self.cancelButtonOutlet.tintColor = colors.titleTextColor
        self.cancelButtonOutlet.layer.cornerRadius = cancelButtonOutlet.bounds.height / 2
        self.cancelButtonOutlet.backgroundColor = colors.titleTextColor.withAlphaComponent(0.15)
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendar.layoutSubviews()
    }
    
    func calendarSettings() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.calendarType = .mini
        calendar.backgroundColor = .clear
        calendar.register(DIYFSCalendarCell.self, forCellReuseIdentifier: "CalendarCell")
    }
    func setActivityTo(_ button: UIButton) {
        
        if endDate == nil {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    func buttonsSettings() {
        saveButton.mainButtonTheme("save_button")
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
    
    //MARK: UNWIND - Выход из календаря назначин на несколько контроллеров, через unwind передает данные на AddScheduler, в TodayBalance дата обновляется самостоятельно спомощью unwindSegue
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
 
    // Сегвей, который передает данные в AddScheduler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard self.endDate     != nil                                               else { return }
        guard segue.identifier == "unwindFromCalendarSegueID"                       else { return }
        guard let destination   = segue.destination as? AddScheduleViewController   else { return }
        destination.date = endDate!
    }
 
}
extension ModalCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard self.cameFromTodayBalance == true else { return nil }
        if diyDatesArray.contains(date) && !date.thisDayisToday() {
            return colors.titleTextColor
        } else if  date.thisDayisToday() {
            return colors.contrastColor1
        } else if date == endDate {
            return colors.contrastColor1
        } else {
            return colors.subtitleTextColor.withAlphaComponent(0.6)
        }
    }
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        <#code#>
//    }
//
    func getDiyArray() {
        var diyArray = [Date]()
        for i in DIYDatesArray {
            let date = Calendar.current.date(from: i)
            diyArray.append(date!)
        }
        self.diyDatesArray = diyArray
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarCell", for: date, at: position) as! DIYFSCalendarCell
        
        cell.setStyle(cellStyle: .defaultCalendar)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard self.cameFromTodayBalance == true else { return }
        configureVisibleCells()
//        guard let endDate = self.endDate else { return }
//        if date == endDate {
//            //  let cell = self.calendar(calendar, cellFor: date, at: monthPosition) as! DIYFSCalendarCell
//
//        }
        //        setDIYDates(startDate: Date(), endDate: endDate)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setDIYDates(startDate: Date(), endDate: date)
        let cell = calendar.cell(for: date, at: monthPosition) as! DIYFSCalendarCell
     
        self.endDate = date
        configureVisibleCells()
        self.getDiyArray()
        calendar.reloadData()
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            //self.configureDIY(cell: cell, for: date!, at: position)
            self.configureEvent(cell: cell, for: date!, at: position)
            //configureToday(cell: cell, for: date!, at: position)
            
        }
        
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
        diyCell.eventView.isHidden = true
        if datesArray.contains(date) {
            diyCell.eventView.isHidden = false
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

