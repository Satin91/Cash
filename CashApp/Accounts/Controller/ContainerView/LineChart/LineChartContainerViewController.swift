//
//  scheduleViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import AAInfographics

class LineChartContainerViewController: UIViewController {
  
    var destinationAccount: MonetaryAccount? 
    var chartElement: [AASeriesElement] = []
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
  

    @objc func receiveObject(_ notification: NSNotification) {
        
        guard let object = notification.object as? MonetaryAccount else {return}
        
        destinationAccount = object
        //Надо подумать как сделать так, чтобы добавление в чарт елемент не происходили постоянно при смене карты
        monthTransactions(account: destinationAccount!)
        collectionView.reloadData()
        
        
    }
    
    func layout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        //layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
      
        collectionView.delegate = self
        collectionView.dataSource = self
        layout()
        print("line container did load ")
        NotificationCenter.default.addObserver(self, selector: #selector(receiveObject(_:)), name: NSNotification.Name(rawValue: "ContainerObject"), object: nil)
        
        let xib = UINib(nibName: "LineChartCell", bundle: nil)
        self.collectionView.register(xib, forCellWithReuseIdentifier: "LineChartIdentifier")
    }
}
extension LineChartContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return chartElement.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LineChartIdentifier", for: indexPath) as! LineChartCell
        cell.contentView.backgroundColor = .clear
       // let object = chartElement[indexPath.row]

        cell.set(element: [chartElement[indexPath.item]]) // В этой функции есть возможность вывести textField при отсутствии елементов
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from.removeOter
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    func monthTransactions(account: MonetaryAccount){
        var accountHistory = [historyStructModel]()
        
        for x in historyObjects {
            if x.accountID == account.accountID {
                accountHistory.append(historyStructModel(name: x.name, sum: x.sum, date: x.date!))
            }
        }
        accountHistory.sort {$0.date < $1.date}
        guard accountHistory.first?.date != nil else {chartElement = [AASeriesElement().name("ArrayIsEmpty")]; return} // Обнулить chartElement чтобы в collection cell можно было вывести textView c отсутствием транзакций
        let firstDate = accountHistory.first!.date
        let endDate = accountHistory.last!.date
        valuesFromInterval(firstDate: firstDate, endDate: endDate, accountHistory: accountHistory)
    }
    
    func valuesFromInterval(firstDate:Date, endDate: Date, accountHistory: [historyStructModel]) {
        chartElement = [] // Как то так. Обнулил при запуске функции чтобы не было бесконечного добавления
        var enumeratedNumbers: [Double] = []
        var startDate = firstDate
        let endDate = endDate // end date в последствии скорее всего придется переименовать в today, чтобы заполнить пропущенные дни
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        var calendar = Calendar.current
        var components = calendar.dateComponents([.month,.year], from: startDate)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        //Создание месячного графика
        while endDate > startDate.endOfMonth {  //
            let interval = DateInterval(start: startDate, end: startDate.endOfMonth)
            for i in accountHistory {
                if interval.contains(i.date){
                    enumeratedNumbers.append(i.sum)
                }
            }
            //Если месяц не окончен
            if enumeratedNumbers.count > 0 { // Запретить добавлять историю, если в месяце нет транзакций
            chartElement.append(AASeriesElement().name(formatter.string(from: startDate)).data(enumeratedNumbers))
            }
            enumeratedNumbers.removeAll()
            components.month! += 1
            startDate = calendar.date(from: components)!
        }
        //создание последнего мемсца
        let interval = DateInterval(start: startDate, end: endDate)
        for x in accountHistory {
            if interval.contains(x.date) {
                enumeratedNumbers.append(x.sum)
            }
        }
        guard enumeratedNumbers.count > 0 else {return} // Запретить добавлять историю, если в месяце нет транзакций
        chartElement.append(AASeriesElement().name(formatter.string(from: startDate)).data(enumeratedNumbers))
    }
}

    
    

