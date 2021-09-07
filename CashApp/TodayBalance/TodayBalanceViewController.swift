//
//  TodayBalanceViewController.swift
//  CashApp
//
//  Created by Артур on 29.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
class SchedulersForTableView {
    var scheduler: MonetaryScheduler
    var todaySum: Double
    init(scheduler: MonetaryScheduler, todaySum: Double) {
        self.scheduler = scheduler
        self.todaySum = todaySum
    }
}
class TodayBalanceViewController: UIViewController {
    
    //MARK: Элементы интерфейса
    private let currencyModelController = CurrencyModelController()
    let calendar = FSCalendarView()
    var calendarContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 26
        view.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        view.layer.cornerRadius = 20
        view.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        view.layer.masksToBounds = false
        
        return view
    }()
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    //var schedulerArray: [MonetaryScheduler] = []
    
    //var payperTimeArray: [PayPerTime] = []
    
    //Switch
    var accSwitchs: [AIFlatSwitch] = {
        var accSwitchs = [AIFlatSwitch]()
        for i in accountsObjects {
            let swt = AIFlatSwitch()
            swt.isSelected = i.isUseForTudayBalance
            accSwitchs.append(swt)
        }
        return accSwitchs
    }()
    var schedulerSwitchs: [AIFlatSwitch] = []
    
    var EXPSchedulerArray: [SchedulersForTableView] = []
    let theme = ThemeManager.currentTheme()
    var todayBalance: TodayBalance? 
    var endDate: Date? {
        willSet {
            updateTotalBalanceSum(animated: true)
            getSchedulersToTableView()
        }
    }
    
    
    //готовность элементов для отображения в балансе
    var isEnableAccountsToTodayBalance = [Bool]()
    var isEnableSchedulersToTodayBalance = [Bool]()
    
    //SegmentedControl
    var changeValue: Bool = true
    @IBOutlet var segmentedControlOutlet: HBSegmentedControl!
    @IBAction func segmentedControl(_ sender: HBSegmentedControl) {
        sender.changeSegmentWithAnimation(tableView: tableView, collectionView: nil, ChangeValue: &changeValue)
    }
    
    @IBOutlet var circleBarContainerView: UIView!
    @IBOutlet var circleBar: CircleView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var calendarButtonContainerView: UIView!
    @IBOutlet var dailyBudgetLabel: UILabel!
    @IBOutlet var dailyBudgetBalanceLabel: UILabel!
    @IBOutlet var calculatedUntilDateLabel: UILabel!
    @IBOutlet var impactOnBalanceLabel: UILabel!
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
    let imageForCalendarButton: UIImageView = { // Это потом надо удалить
        let image = UIImageView()
        image.image = UIImage(named: "calendarForButton")
        image.frame = .zero
        return image
    }()
   
  

    //MARK: life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hideTabBar()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.addTarget(self, action: #selector(calendarButtonPressed(_:)), for: .touchUpInside)
        updateTotalBalanceSum(animated: false)
        setTodayBalanceData(animated: false) // Это на случай если не сработает обновление данных
        visualSettings()
        installCalendar()
        setupTableView()
        getSchedulersToTableView()
        createConstraints()
        
    }
    
    //MARK: - GETSCHEDULERS TO TABLE VIEW
    func getSchedulersToTableView(){
       // var schedulerArray: [MonetaryScheduler] = []
        var sschedulerArray: [SchedulersForTableView] = []
        guard let todayBalance = todayBalanceObject else {return}
        let divider = getDivider()
        for i in oneTimeObjects {
            if i.date! <= todayBalance.endDate {
                    sschedulerArray.append(SchedulersForTableView(scheduler: i, todaySum: (i.target - i.available) / Double(divider)))
            }
        }
        for i in goalObjects {
            if i.date! <= todayBalance.endDate {
                if  divider == 0 {
                    sschedulerArray.append(SchedulersForTableView(scheduler: i, todaySum: (i.target - i.available)))
                }else{
                    sschedulerArray.append(SchedulersForTableView(scheduler: i, todaySum: (i.target - i.available) / Double(divider)))
                }
            }
        }
        var scheduleID: String?// Местная переменная для исключения повторов
      
        struct payPerSumAndID {
            var schID: String
            var schlPaySum: Double
            var date: Date
        }
        
        var totalPayPerSum: [payPerSumAndID] = [] // переменная для подсчета общей суммы разовых платежей
        var counter = 0
        //подсчет суммы для разовых платежей
        for i in payPerTimeObjects {
            if i.scheduleID != scheduleID{
                counter += 1
                totalPayPerSum.append(payPerSumAndID(schID: i.scheduleID , schlPaySum: i.target, date: i.date))
                scheduleID = i.scheduleID
            }else{
                if i.date <= todayBalance.endDate {
                totalPayPerSum[counter - 1].schlPaySum += i.target
                totalPayPerSum[counter - 1].date = i.date
            }
            }
        }
        //Рассчет дневной суммы для корректировки бюджета
        counter = 0
        for i in totalPayPerSum {
            totalPayPerSum[counter].schlPaySum = i.schlPaySum / Double(divider)
            counter += 1
        }
        counter = 0
        scheduleID = nil
        for i in payPerTimeObjects {
            if i.date <= todayBalance.endDate {
                
                for scheduler in EnumeratedSchedulers(object: schedulerGroup) {
                    if i.scheduleID == scheduler.scheduleID && i.scheduleID != scheduleID {
                        sschedulerArray.append(SchedulersForTableView(scheduler: scheduler, todaySum: totalPayPerSum[counter].schlPaySum) )
                        counter += 1
                        scheduleID = scheduler.scheduleID
                    }else{
                        continue
                    }
                }
            }
        }
        schedulerSwitchs = []
        for i in sschedulerArray {
            let switchs = AIFlatSwitch()
            switchs.isSelected = i.scheduler.isUseForTudayBalance
            schedulerSwitchs.append(switchs)
        }
        self.EXPSchedulerArray = sschedulerArray
        tableView.reloadData()
    }
    
    func setEmptyBalanceData() {
        guard let mainCurrency = mainCurrency else {return}
        dailyBudgetBalanceLabel.countISOAnimation(upto: 0, iso: mainCurrency.ISO)
        dailyBudgetLabel.text = NSLocalizedString("empty_accounts", comment: "")
        circleBar.progressAnimation(currentlyBalance: 0, commonBalance: 0)
        
    }
    func getDivider()-> Int {
        var divider: Int = 0
        guard todayBalanceObject != nil else {return 0}
        
        if todayBalanceObject!.endDate > Date() {
            divider = Calendar.current.dateComponents([.day], from: Date(),to: todayBalanceObject!.endDate).day! + 2 // Сегодня и последний день включительно
        }else {
            divider = 1
        }
        return divider
    }
    func setTodayBalanceData(animated: Bool) {
        guard let mainCurrency = mainCurrency?.ISO else {return}
        guard let balance = todayBalanceObject else {
            dailyBudgetBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency, Balance: 0, additionalText: nil)
            calculatedUntilDateLabel.text = NSLocalizedString("date_not_selected_label", comment: "")
            return}
        //endDate = todayBalanceObject?.endDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd"
        calculatedUntilDateLabel.text = NSLocalizedString("date_not_selected_label", comment: "") + formatter.string(from: balance.endDate)
        dailyBudgetLabel.text = NSLocalizedString("dayly_budget_label", comment: "")
        var currentBalance: Double = 0
        let divider = getDivider()
        currentBalance = divider != 0 ? balance.currentBalance / Double(divider) : balance.currentBalance
        
        if animated {
            dailyBudgetBalanceLabel.countISOAnimation(upto: currentBalance, iso: mainCurrency)
        }else{
            dailyBudgetBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency, Balance: currentBalance, additionalText: nil)
        }
    }
    func updateTotalBalanceSum(animated: Bool) {
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
        setTodayBalanceData(animated: animated)
        circleBar.progressAnimation(currentlyBalance: todayBalanceObject!.currentBalance, commonBalance: todayBalanceObject!.commonBalance)
    }
    
    @objc func calendarButtonPressed(_ button: UIButton) {
        calendarContainerView.center = self.view.center
        calendar.center = calendarContainerView.center
        
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        self.view.animateViewWithBlur(animatedView: calendarContainerView, parentView: self.view)
        
        self.view.animateViewWithBlur(animatedView: calendar, parentView: self.view)
    }
    
   
    
    
    
}


extension TodayBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        changeValue ? EXPSchedulerArray.count : accountsObjects.count
    }
    
    func insertSwitchInCell(_ AISwitch:AIFlatSwitch, cell: UITableViewCell) {
        AISwitch.removeFromSuperview()
        let size: CGFloat = 35
        let xPos:CGFloat = cell.bounds.width - 40 - (size / 2)
        let yPos: CGFloat = cell.bounds.height / 2 - (size / 2)
        cell.addSubview(AISwitch)
        AISwitch.frame = CGRect(x: xPos, y: yPos, width: size, height: size)
        //AISwitch.center.y = cell.center.y
        AISwitch.isEnabled = false
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayBalanceTableViewCell.identifier,for: indexPath) as! TodayBalanceTableViewCell
        cell.selectionStyle = .none
        
        switch changeValue {
        case true:
            let switchs = schedulerSwitchs[indexPath.row]
            let object = EXPSchedulerArray[indexPath.row]
            switchs.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            switchs.isSelected = object.scheduler.isUseForTudayBalance
            cell.accessoryView = switchs
            cell.accessoryView?.isUserInteractionEnabled = false
            cell.set(object: object)
            //cell.accessoryView?.backgroundColor = .clear
            return cell
        case false:
            let object = accountsObjects[indexPath.row]
            let switchs = accSwitchs[indexPath.row]
            switchs.isSelected = object.isUseForTudayBalance
            switchs.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            cell.accessoryView = switchs
            cell.accessoryView?.isUserInteractionEnabled = false
            cell.set(object: object)
            
            return cell
        }
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if changeValue {
            let SHObject = EXPSchedulerArray[indexPath.row].scheduler
            
            let swit = schedulerSwitchs[indexPath.row]
            try! realm.write {
                SHObject.isUseForTudayBalance.toggle()
                realm.add(SHObject,update: .all)
            }
            swit.setSelected(!swit.isSelected , animated: true)
        }else{
            
            let ACCObject = accountsObjects[indexPath.row]
            let swit = accSwitchs[indexPath.row]
            try! realm.write {
                ACCObject.isUseForTudayBalance.toggle()
                realm.add(ACCObject,update: .all)
            }
            swit.setSelected(!swit.isSelected , animated: true)
        }
        updateTotalBalanceSum(animated: true)
    }
    
    
}
