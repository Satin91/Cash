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
    
    var endDate: Date? {
        willSet {
            calculatedUntilDateLabel.text = "Calculated until " + dateToString(date: newValue!)
            setTodayBalance()
            getSchedulers()
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
        updateDatesArray()
        print(datesArray)
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
    func setTodayBalance() {
        guard let mainCurrency = mainCurrency?.ISO else {return}
        var commonBalance: Double = 0
        var divider: Int = 0
        if todayBalanceObject!.endDate > Date() {
            divider = Calendar.current.dateComponents([.day], from: Date(),to: todayBalanceObject!.endDate).day!
        }else{
            divider = 0
        }
        
        for i in accountsObjects {
            if i.currencyISO != mainCurrency {
                commonBalance += currencyModelController.convert(i.balance, inputCurrency: i.currencyISO, outputCurrency: mainCurrency)!
            }else{
                commonBalance += i.balance
            }
        }
        commonBalance = divider != 0 ? commonBalance / Double(divider) : commonBalance
        dailyBudgetBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency, Balance: commonBalance)
        //balanceLabel.text = String(totalBalanceSum.currencyFormatter(ISO: validCurrency.ISO))
    }
    func getSchedulers(){
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
    func getDailyBalance() {
        guard let balance = todayBalanceObject else {
            dailyBudgetBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency!.ISO, Balance: 0)
            dailyBudgetLabel.text = "Date not selected"
            return}
        
        setTodayBalance()
        endDate = todayBalanceObject?.endDate
        calculatedUntilDateLabel.text = dateToString(date: endDate!)
        dailyBudgetBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency!.ISO, Balance: balance.currentBalance)
    }
    var datesArray: [Date] = []
    func updateDatesArray() {
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
        self.datesArray = datesArray
    }
    func installCircleBar() {
        circleBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    @objc func handleTap() {
        circleBar.progressAnimation(duration: 0.6)
    }
    
    @objc func calendarButtonPressed(_ button: UIButton) {
        print("pressed")
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendarContainerView, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendar, parentView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hideTabBar()
        circleBar.progressAnimation(duration: 0.6)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    func checkActiveObjects() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.addTarget(self, action: #selector(calendarButtonPressed(_:)), for: .touchUpInside)
        visualSettings()
        createConstraints()
        getDailyBalance()
        installCalendar()
        setTodayBalance()
        installTableView()
        getSchedulers()
        installCircleBar()
    }

}

extension TodayBalanceViewController: FSCalendarDelegateAppearance,FSCalendarDelegate,FSCalendarDataSource {
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let a = uniq(source: datesArray)
        print(a)
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
        
        try! realm.write{
            let todayBalance = TodayBalance()
            if todayBalanceObject == nil {
                todayBalance.endDate = date
                realm.add(todayBalance)
            }else{
                todayBalanceObject?.endDate = date
                realm.add(todayBalanceObject!,update: .all)
            }
        }
        endDate = date
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
    
    
}
