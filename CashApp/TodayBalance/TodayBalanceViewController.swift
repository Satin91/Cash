//
//  TodayBalanceViewController.swift
//  CashApp
//
//  Created by Артур on 29.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
class TodayBalanceViewController: UIViewController {
    
    
    let theme = ThemeManager.currentTheme()
    let currencyModelController = CurrencyModelController()
    let calendar = FSCalendarView()
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var schedulerArray: [MonetaryScheduler] = []
    var payperTimeArray: [PayPerTime] = []
    var todayBalance: TodayBalance? 
    var endDate: Date? {
        willSet {
            
            updateTotalBalanceSum()
            getSchedulersToTableView()
            
        }
        
    }
    var changeValue: Bool = true
    @IBOutlet var segmentedControlOutlet: HBSegmentedControl!
    @IBAction func segmentedControl(_ sender: HBSegmentedControl) {
        sender.changeSegmentWithAnimation(TableView: tableView, ChangeValue: &changeValue)
    }
    var calendarContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 26
        view.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        view.layer.cornerRadius = 20
        view.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        view.layer.masksToBounds = false
        
        return view
    }()
    @IBOutlet var circleBarContainerView: UIView!
    @IBOutlet var circleBar: CircleView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var calendarButtonContainerView: UIView!
    @IBOutlet var dailyBudgetLabel: UILabel!
    @IBOutlet var calculatedUntilDateLabel: UILabel!
    @IBOutlet var dailyBudgetBalanceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var containerForTableView: UIView = {
       let view = UIView()
        view.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        view.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        view.frame = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var calendarButton: UIButton = {
        let button = UIButton()
        button.frame = .zero
        return button
    }()
    let imageForCalendarButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "calendar")
        image.frame = .zero
        return image
    }()
    func installTableView() {
        self.view.addSubview(containerForTableView)
        initConstraints(view: containerForTableView, to: tableView)
        self.view.bringSubviewToFront(tableView)
        containerForTableView.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TodayBalanceTableViewCell.nib(), forCellReuseIdentifier: TodayBalanceTableViewCell.identifier)
    }
    func installCalendar(){
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: DIYCalendarCell.identifier)
        updateTotalBalanceSum()
    }
    func visualSettings() {
        //view
        containerView.backgroundColor = theme.secondaryBackgroundColor
        containerView.layer.setMiddleShadow(color: theme.shadowColor)
        containerView.layer.cornerRadius = 30
        circleBarContainerView.backgroundColor = theme.secondaryBackgroundColor
        circleBarContainerView.layer.cornerRadius = 20
        circleBarContainerView.layer.setSmallShadow(color: theme.shadowColor)
        segmentedControlOutlet.changeValuesForCashApp(segmentOne: "Plans", segmentTwo: "Accounts")
        calendarButtonContainerView.layer.cornerRadius = 12
        calendarButtonContainerView.backgroundColor = theme.contrastColor1
        blur.frame = self.view.bounds
        calendar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.6)
        calendarContainerView.frame = calendar.frame
        imageForCalendarButton.setImageColor(color: theme.secondaryBackgroundColor)
        //labels
        dailyBudgetLabel.textColor = theme.titleTextColor
        calculatedUntilDateLabel.textColor = theme.subtitleTextColor
        dailyBudgetBalanceLabel.textColor = theme.titleTextColor
        //labels font weight and size
        dailyBudgetLabel.font = .systemFont(ofSize: 19, weight: .medium)
        calculatedUntilDateLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dailyBudgetBalanceLabel.font = .systemFont(ofSize: 46, weight: .medium)
    }
    func createConstraints() {
        calendarButtonContainerView.addSubview(calendarButton)
        calendarButtonContainerView.addSubview(imageForCalendarButton)
        initConstraints(view: imageForCalendarButton, to: calendarButtonContainerView)
        initConstraints(view: calendarButton, to: calendarButtonContainerView)
    }
   
    func getSchedulersToTableView(){
        var schedulerArray: [MonetaryScheduler] = []
        guard let todayBalance = todayBalanceObject else{return}
        for i in EnumeratedSchedulers(object: schedulerGroup) {
            if i.date! <= todayBalance.endDate {
                schedulerArray.append(i)
            }
        }
        self.schedulerArray = schedulerArray
        tableView.reloadData()
    }

    func setEmptyBalanceData() {
        guard let mainCurrency = mainCurrency else {return}
        dailyBudgetBalanceLabel.countISOAnimation(upto: 0, iso: mainCurrency.ISO)
        dailyBudgetLabel.text = "Отсутствуют счета"
        circleBar.progressAnimation(currentlyBalance: 0, commonBalance: 0)
        
    }
    
    func setTodayBalanceData() {
        guard let mainCurrency = mainCurrency?.ISO else {return}
        guard let balance = todayBalanceObject else {
            dailyBudgetBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency, Balance: 0)
            calculatedUntilDateLabel.text = "Date not selected"
            return}
        //endDate = todayBalanceObject?.endDate
        calculatedUntilDateLabel.text = "Calculated until " + dateToString(date: balance.endDate)
        dailyBudgetLabel.text = "Daily budget"
        var currentBalance: Double = 0
        var divider: Int = 0
        if balance.endDate > Date() {
            divider = Calendar.current.dateComponents([.day], from: Date(),to: balance.endDate).day!
        }else{
            divider = 0
        }
        currentBalance = divider != 0 ? balance.currentBalance / Double(divider) : balance.currentBalance
        dailyBudgetBalanceLabel.countISOAnimation(upto: currentBalance, iso: mainCurrency)
    }
    func updateTotalBalanceSum() {
        //minuend, subtrahend, difference
        //уменьшаемое, вычитаемое, разность
        todayBalanceObject = fetchTodayBalance()
        var subtrahend: Double = 0
        var commonSum: Double = 0
        
        //Get current balance
        guard let endDate = todayBalanceObject?.endDate else {return}
            for i in payPerTimeObjects{
                for schedulers in EnumeratedSchedulers(object: schedulerGroup) {
                    if i.scheduleID == schedulers.scheduleID && schedulers.isUseForTudayBalance && i.date <= endDate {
                        subtrahend += currencyModelController.convert(i.vector ? +i.target : -i.target, inputCurrency: i.currencyISO, outputCurrency: mainCurrency?.ISO)!
                        
                    }
                }
            }
            for x in Array(oneTimeObjects) {
                if x.isUseForTudayBalance && x.date! <= endDate {
                    subtrahend += currencyModelController.convert(x.vector ? +x.target : -x.target, inputCurrency: x.currencyISO, outputCurrency: mainCurrency?.ISO)!
                }
            }
            for y in Array(goalObjects) {
                if y.isUseForTudayBalance && y.date! <= endDate {
                    subtrahend += currencyModelController.convert(y.vector ? +y.target : -y.target, inputCurrency: y.currencyISO, outputCurrency: mainCurrency?.ISO)!
                }
            }
        //Get CommonSum
        var usedAccauntArray: [MonetaryAccount] = []
        for a in accountsObjects {
            if a.isUseForTudayBalance == true {
                commonSum += currencyModelController.convert(a.balance, inputCurrency: a.currencyISO, outputCurrency: mainCurrency?.ISO)!
                usedAccauntArray.append(a)
            }
        }
        
        try! realm.write {
            todayBalanceObject?.commonBalance = commonSum.removeHundredthsFromEnd()
            todayBalanceObject?.currentBalance = (commonSum + subtrahend).removeHundredthsFromEnd()
            realm.add(todayBalanceObject!,update: .all)
        }
        guard usedAccauntArray.isEmpty == false else {
            setEmptyBalanceData()
            return}
        setTodayBalanceData()
        circleBar.progressAnimation(currentlyBalance: todayBalanceObject!.currentBalance, commonBalance: todayBalanceObject!.commonBalance)
    }
    
    @objc func calendarButtonPressed(_ button: UIButton) {
        
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendarContainerView, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendar, parentView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hideTabBar()
        updateTotalBalanceSum()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.addTarget(self, action: #selector(calendarButtonPressed(_:)), for: .touchUpInside)
     
        visualSettings()
        createConstraints()
        installCalendar()
        
        installTableView()
        getSchedulersToTableView()
    }
    
    

}

extension TodayBalanceViewController: FSCalendarDelegateAppearance,FSCalendarDelegate,FSCalendarDataSource {
    
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
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
       // let a = uniq(source: datesArray)
        let datesArray: [Date] = updateDatesArray()
        if datesArray.contains(date) {
            return 1
            
        }else{
            return 0
        }
//
//        if a.contains(date) {
//            return a.count + 1
//        }else{
//            return 0
//        }
    }
    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: DIYCalendarCell.identifier, for: date, at: position)
//        
//        
//        return cell
//    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
              
        //Так как создается баланс только при выборе даты, эту конструкцию нужно указывать только здесь
        do {
            try todayBalanceObject = DBManager.fetchTB(date: date)
        } catch let error {
            try! realm.write {
                realm.add(TodayBalance(commonBalance: 0, currentBalance: 0, endDate: date))
            }
            print (error.localizedDescription)
        }
        

        endDate = date
        updateTotalBalanceSum()
        
        self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView2(animatedView: calendarContainerView)
        self.view.reservedAnimateView2(animatedView: self.calendar)
    }
    
    
    
}
extension TodayBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        changeValue ? schedulerArray.count : accountsObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayBalanceTableViewCell.identifier,for: indexPath) as! TodayBalanceTableViewCell
        cell.selectionStyle = .none
        switch changeValue {
        case true:
            let object = schedulerArray[indexPath.row]
            cell.set(object: object)
            return cell
        case false:
            let object = accountsObjects[indexPath.row]
            cell.set(object: object)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if changeValue {
            let object = schedulerArray[indexPath.row]
            try! realm.write {
                object.isUseForTudayBalance.toggle()
                realm.add(object,update: .all)
            }
        }else{
            let object = accountsObjects[indexPath.row]
            try! realm.write {
                object.isUseForTudayBalance.toggle()
                realm.add(object,update: .all)
            }
        }
        updateTotalBalanceSum()
        
    }
    
    
}
