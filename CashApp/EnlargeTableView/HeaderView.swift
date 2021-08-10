//
//  HeaderView.swift
//  CashApp
//
//  Created by Артур on 28.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Charts
protocol prepareForMainViewControllers {
    func prepareFor(viewController: UIViewController)
}

final class HeaderView: UIViewController {

    var chartView = ChartView()
    let themeManager = ThemeManager.currentTheme()
    let currencyModelController = CurrencyModelController()
    
    var delegate: prepareForMainViewControllers!
    var dateLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Date"
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.frame = .zero
        label.layer.opacity = 0
        return label
    }()

    var accountsButton: UIButton = {
       let button = UIButton()
        button.frame = .zero
        button.backgroundColor = .clear
        button.setTitle(" ", for: .normal)
        return button
    }()
    
    var accountsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .medium)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.text = "Accounts"
        return label
        
    }()
    var totalBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .medium)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "0"
        return label
        
    }()
    var todayBalanceButton: UIButton = {
        let button = UIButton()
        button.frame = .zero
        button.backgroundColor = .clear
        button.setTitle(" ", for: .normal)
        return button
    }()
    
    var todayBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.text = "Budget today"
        return label
    }()
    
    var todayBalanceSumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.text = "0"
        return label
    }()
    
    let lineView: UIView = {
       let line = UIView()
       return line
    }()
    
    func getTodayBalance() -> Double {
        guard let balance = todayBalanceObject else {return 0}
        var dateCount: Int = 0
        
        if balance.endDate > Date() {
            dateCount = Calendar.current.dateComponents([.day], from: Date(),to: balance.endDate).day! + 2
        }else{
            dateCount = 1
        }
        
        
        return balance.currentBalance / Double(dateCount)
    }
    func initControls() {
        accountsButton.addTarget(self, action: #selector(prepareForAccounts), for: .touchUpInside)
        todayBalanceButton.addTarget(self, action: #selector(prepareForTodayBalance), for: .touchUpInside)
        
        
        self.view.addSubview(dateLabel)
        self.view.addSubview(accountsButton)
        self.view.addSubview(todayBalanceButton)
        self.view.addSubview(lineView)
        accountsButton.addSubview(chartView)
        accountsButton.addSubview(accountsLabel)
        accountsButton.addSubview(totalBalanceLabel)
        todayBalanceButton.addSubview(todayBalanceLabel)
        todayBalanceButton.addSubview(todayBalanceSumLabel)
    }
    
    func setAccountsBalance(){
        guard let mainCurrency = mainCurrency?.ISO else {return}
        var totalBalance: Double = 0
        for i in accountsObjects {
            print(mainCurrency)
            totalBalance += currencyModelController.convert(i.balance, inputCurrency: i.currencyISO, outputCurrency: mainCurrency) ?? 0
        }
        totalBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency, Balance: totalBalance , additionalText: nil)
    }
    func setTodayBalance() {
        var todayExpences: Double = 0
        guard let mainCurrency = mainCurrency else {
            todayBalanceLabel.text = "0"
            return}
        let today = Calendar.current.dateComponents([.day,.year,.month], from: Date())
        
        for i in historyObjects {
            let day = Calendar.current.dateComponents([.day,.year,.month], from: i.date)
            if day == today && i.accountID != "NO ACCOUNT"{
                
                todayExpences += currencyModelController.convert(i.sum, inputCurrency: i.currencyISO, outputCurrency: mainCurrency.ISO)!
                
            }
        }
        let addNumber = todayExpences != 0 ? "(\(todayExpences.fromNumberToString()))" : ""
            //
        let additionalText = (addNumber ,todayExpences > 0 ? ThemeManager.currentTheme().contrastColor1: ThemeManager.currentTheme().contrastColor2)
        todayBalanceSumLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency.ISO, Balance: getTodayBalance() + todayExpences, additionalText: additionalText)
    }
    func setColorTheme() {
        lineView.backgroundColor = themeManager.separatorColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAccountsBalance()
        setTodayBalance()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 35
        self.view.layer.shadowOpacity = 0.20
        self.view.layer.shadowColor = themeManager.shadowColor.cgColor
        self.view.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.view.layer.shadowRadius = 15
        self.view.layer.masksToBounds = false
        
        
        
        initControls()
        setColorTheme()
        createConstraints()
        setAccountsBalance()
        setChartData()
        dateLabel.center = self.view.center
    }

    @objc func prepareForAccounts(){
        let accVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AccountsViewController") as! AccountsViewController
        delegate.prepareFor(viewController: accVC)
    }
    
    @objc func prepareForTodayBalance(){
        let tdbVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TodayBalanceViewController") as! TodayBalanceViewController
        delegate.prepareFor(viewController: tdbVC)
    }
    
    func showButtons() {
        UIView.animate(withDuration: 0.2) {
            if self.accountsButton.layer.opacity == 0,self.todayBalanceButton.layer.opacity == 0 {
                self.accountsButton.layer.opacity = 1
                self.todayBalanceButton.layer.opacity = 1
                self.lineView.layer.opacity = 1
                self.dateLabel.layer.opacity = 0
            }
        }
    }
    func HideButtons() {
        UIView.animate(withDuration: 0.2) {
            if self.accountsButton.layer.opacity == 1,self.todayBalanceButton.layer.opacity == 1 {
                self.accountsButton.layer.opacity = 0
                self.todayBalanceButton.layer.opacity = 0
                self.lineView.layer.opacity = 0
                self.dateLabel.layer.opacity = 1
            }
        }
    }
    
    
    
    func createConstraints() {
        //label
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        //Account button
        NSLayoutConstraint.activate([
            accountsButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            accountsButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            accountsButton.topAnchor.constraint(equalTo: self.view.topAnchor),
            accountsButton.heightAnchor.constraint(equalToConstant: 157)
        ])
        NSLayoutConstraint.activate([
            accountsLabel.leadingAnchor.constraint(equalTo: accountsButton.leadingAnchor,constant: 20),
            accountsLabel.topAnchor.constraint(equalTo: accountsButton.topAnchor,constant: 18)
        ])
        NSLayoutConstraint.activate([
            totalBalanceLabel.leadingAnchor.constraint(equalTo: accountsButton.leadingAnchor,constant: 20),
            totalBalanceLabel.trailingAnchor.constraint(equalTo: accountsButton.trailingAnchor,constant: -20),
            totalBalanceLabel.topAnchor.constraint(equalTo: accountsLabel.bottomAnchor,constant: 8)
        ])
        //TodayBalance button
        NSLayoutConstraint.activate([
            todayBalanceButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            todayBalanceButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            todayBalanceButton.topAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -97),
            todayBalanceButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            todayBalanceLabel.leadingAnchor.constraint(equalTo: todayBalanceButton.leadingAnchor,constant: 20),
            todayBalanceLabel.topAnchor.constraint(equalTo: todayBalanceButton.topAnchor,constant: 14)
        ])
        
        NSLayoutConstraint.activate([
            todayBalanceSumLabel.leadingAnchor.constraint(equalTo: accountsButton.leadingAnchor,constant: 20),
            todayBalanceSumLabel.trailingAnchor.constraint(equalTo: accountsButton.trailingAnchor,constant: -20),
            todayBalanceSumLabel.topAnchor.constraint(equalTo: todayBalanceLabel.bottomAnchor,constant: 8)
        ])

        
        //ChartsView
        
        NSLayoutConstraint.activate([
        chartView.bottomAnchor.constraint(equalTo: lineView.topAnchor,constant: -6),
        chartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        chartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -self.view.bounds.width / 2),
        chartView.topAnchor.constraint(equalTo: totalBalanceLabel.bottomAnchor)
        ])
        
        
        //LineView
        NSLayoutConstraint.activate([
        lineView.bottomAnchor.constraint(equalTo: todayBalanceButton.topAnchor,constant: 6),
        lineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        lineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        lineView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        todayBalanceSumLabel.translatesAutoresizingMaskIntoConstraints = false
        todayBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        todayBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        totalBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsButton.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
extension UIView {
    
    var middleShadow: UIView {
     let view = UIView()
        view.layer.shadowOpacity = 0.14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 15
        return view
        
    }
    
}
extension HeaderView: ChartViewDelegate {
    
    func setChartData() {
        
        
        var historyValues: [ChartDataEntry] = []
        var historyData: [AccountsHistory] = []
        
        var x: Double = 0
        for i in historyObjects {
            
            if i.scheduleID != "NO ACCOUNT"{
                historyData.append(i)
            }
        }
        historyData.sort { ($0.date < $1.date) }
        for (index,value) in historyData.enumerated() {
            
            if index >= historyData.count - 6 {
            historyValues.append(ChartDataEntry(x: x, y: value.sum))
            x += 5
            }
        }

      
        chartView.delegate = self
        let set = LineChartDataSet(entries: historyValues)
        set.drawCirclesEnabled = false
        set.circleRadius = 40
        set.lineWidth = 2
        set.setColor(ThemeManager.currentTheme().contrastColor2)
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data
        
      //  chartView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
   
}
