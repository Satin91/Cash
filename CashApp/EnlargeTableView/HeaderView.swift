//
//  HeaderView.swift
//  CashApp
//
//  Created by Артур on 28.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Charts
import Themer
protocol prepareForMainViewControllers {
    func prepareFor(viewController: UIViewController)
}

final class HeaderView: UIViewController {
    
    var chartView = ChartView()
    let themeManager = ThemeManager2.currentTheme()
    let currencyModelController = CurrencyModelController()
    var chartLineColor: UIColor = .clear { // Цвет для графика(вынесено сюда для стороннего изменения так как в графике нельзя установить переменный цвет
        didSet{
            setChartData() // Обновить цвет
            
        }
    }


    
    var delegate: prepareForMainViewControllers!
    var dateLabel: TitleLabel = {
        let label = TitleLabel()
        label.backgroundColor = .clear
        label.text = "Date"
        label.font = .boldSystemFont(ofSize: 34)
       // label.textColor = ThemeManager2.currentTheme().titleTextColor
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
    
    var accountsLabel: TitleLabel = {
        let label = TitleLabel()
        label.font = .systemFont(ofSize: 23, weight: .medium)
      //  label.textColor = ThemeManager2.currentTheme().titleTextColor
        label.text = NSLocalizedString("header_accounts", comment: "")
        return label
        
    }()
    var totalBalanceLabel: TitleLabel = {
        let label = TitleLabel()
        label.font = .systemFont(ofSize: 34, weight: .regular)
        //label.textColor = ThemeManager2.currentTheme().titleTextColor
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
    
    var todayBalanceLabel: TitleLabel = {
        let label = TitleLabel()
        label.font = .systemFont(ofSize: 19, weight: .medium)
      //  label.textColor = ThemeManager2.currentTheme().titleTextColor
        label.text = NSLocalizedString("header_budgetToday", comment: "")
        return label
    }()
    
    var todayBalanceSumLabel: TitleLabel = {
        let label = TitleLabel()
        label.font = .systemFont(ofSize: 26, weight: .regular)
     //   label.textColor = ThemeManager2.currentTheme().titleTextColor
        label.text = "0"
        return label
    }()
    
    var accountsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header.wallet")
       // imageView.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return imageView
    }()
    
    var todayBalanceImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header.todayBalance")
      //  imageView.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return imageView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAccountsBalance()
        setTodayBalance()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Themer.shared.register(target: self, action: HeaderView.theme(_:))
        self.view.layer.cornerRadius = 28
        initControls()

        createConstraints()
        setAccountsBalance()
        setChartData()
        dateLabel.center = self.view.center
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
        accountsButton.addSubview(accountsImage)
        todayBalanceButton.addSubview(todayBalanceLabel)
        todayBalanceButton.addSubview(todayBalanceSumLabel)
        todayBalanceButton.addSubview(todayBalanceImage)
    }
    
    func setAccountsBalance(){
        guard let mainCurrency = mainCurrency?.ISO else {return}
        var totalBalance: Double = 0
        for i in accountsObjects {
            totalBalance += currencyModelController.convert(i.balance, inputCurrency: i.currencyISO, outputCurrency: mainCurrency) ?? 0
        }
        totalBalanceLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency, Balance: totalBalance , additionalText: nil)
    }
    func setTodayBalance() {
        var todayExpenses: Double = 0
        guard let mainCurrency = mainCurrency else {
            todayBalanceLabel.text = "0"
            return}
        
        let today = Calendar.current.dateComponents([.day,.year,.month], from: Date())
        for i in historyObjects {
            let day = Calendar.current.dateComponents([.day,.year,.month], from: i.date)
            if day == today && i.accountID != "NO ACCOUNT"{
                todayExpenses += currencyModelController.convert(i.sum, inputCurrency: i.currencyISO, outputCurrency: mainCurrency.ISO) ?? 0
            }
        }
        let addNumber = todayExpenses != 0 ? "(\(todayExpenses.fromNumberToString()))" : ""
        //
        let additionalText = (addNumber ,todayExpenses > 0 ? ThemeManager2.currentTheme().contrastColor1: ThemeManager2.currentTheme().contrastColor2)
        todayBalanceSumLabel.changeTextAttributeForFirstLiteralsISO(ISO: mainCurrency.ISO, Balance: getTodayBalance() + todayExpenses, additionalText: additionalText)
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
            accountsImage.leadingAnchor.constraint(equalTo: accountsButton.leadingAnchor,constant: 20),
            accountsImage.topAnchor.constraint(equalTo: accountsButton.topAnchor,constant: 19),
            accountsImage.widthAnchor.constraint(equalToConstant: 26),
            accountsImage.heightAnchor.constraint(equalToConstant: 26),
        ])
        NSLayoutConstraint.activate([
            accountsLabel.leadingAnchor.constraint(equalTo: accountsImage.trailingAnchor,constant: 4),
            accountsLabel.topAnchor.constraint(equalTo: accountsButton.topAnchor,constant: 18)
        ])
        NSLayoutConstraint.activate([
            totalBalanceLabel.leadingAnchor.constraint(equalTo: accountsButton.leadingAnchor,constant: 20),
            totalBalanceLabel.trailingAnchor.constraint(equalTo: accountsButton.trailingAnchor,constant: -20),
            totalBalanceLabel.topAnchor.constraint(equalTo: accountsLabel.bottomAnchor,constant: 12)
        ])
        //TodayBalance button
        NSLayoutConstraint.activate([
            todayBalanceButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            todayBalanceButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            todayBalanceButton.topAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -97),
            todayBalanceButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            todayBalanceImage.leadingAnchor.constraint(equalTo: todayBalanceButton.leadingAnchor,constant: 20),
            todayBalanceImage.topAnchor.constraint(equalTo: todayBalanceButton.topAnchor,constant: 12),
            todayBalanceImage.widthAnchor.constraint(equalToConstant: 26),
            todayBalanceImage.heightAnchor.constraint(equalToConstant: 26),
        ])
        NSLayoutConstraint.activate([
            todayBalanceLabel.leadingAnchor.constraint(equalTo: todayBalanceImage.trailingAnchor,constant: 4),
            //todayBalanceLabel.centerYAnchor.constraint(equalTo: todayBalanceImage.centerYAnchor)
            todayBalanceLabel.topAnchor.constraint(equalTo: todayBalanceButton.topAnchor,constant: 16)
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
        todayBalanceImage.translatesAutoresizingMaskIntoConstraints = false
        accountsButton.translatesAutoresizingMaskIntoConstraints = false
        accountsLabel.translatesAutoresizingMaskIntoConstraints = false
        accountsImage.translatesAutoresizingMaskIntoConstraints = false
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
//extension HeaderView: Themable {
//    func applyTheme(_ theme: MyTheme) {

//        lineView.backgroundColor = theme.settings.separatorColor
//    }
//
//
//}
extension HeaderView {
    func theme(_ theme: MyTheme) {
        accountsImage.setImageColor(color: theme.settings.titleTextColor)
        todayBalanceImage.setImageColor(color: theme.settings.titleTextColor)
        view.backgroundColor = theme.settings.secondaryBackgroundColor
        lineView.backgroundColor = theme.settings.separatorColor
        self.view.layer.setMiddleShadow(color: theme.settings.shadowColor)
        chartLineColor = theme.settings.contrastColor2
        
//        let CAL = CALayer()
//        CAL.shadowColor = theme.settings.shadowColor.cgColor
//        CAL.shadowOffset = CGSize(width: 0, height: 10)
//       // CAL.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
//        // shouldRasterize = true
//        CAL.shadowRadius = 40
//        CAL.shadowOpacity = 0.10
//        CAL.shouldRasterize = true
//        CAL.rasterizationScale = UIScreen.main.scale
//        self.view.layer.insertSublayer(CAL, at: 0)
        

    }
    func chartColor(chart: LineChartDataSet,_ theme: MyTheme){
        chart.setColor(theme.settings.contrastColor2)
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
        chartView.isUserInteractionEnabled = false
        let set = LineChartDataSet(entries: historyValues)
        set.drawCirclesEnabled = false
        set.circleRadius = 40
        set.lineWidth = 2
        
        //Themer.shared.register(target: self, action: HeaderView.chartColor(set) )
        set.setColor(chartLineColor)
        
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data
        
        //  chartView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}
