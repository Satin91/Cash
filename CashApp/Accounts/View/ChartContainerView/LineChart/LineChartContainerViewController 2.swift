//
//  scheduleViewController.swift
//  CashApp
//
//  Created by Артур on 11/11/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import Charts
struct LineChartDataModel {
    var chartDataSet = LineChartDataSet()
    var date: Date = Date()
    var account: MonetaryAccount = MonetaryAccount()
}

class LineChartContainerViewController: UIViewController {
   let colors = AppColors()
    
    var lineChartDefinition: [LineChartDataModel] = []
    
    var destinationAccount: MonetaryAccount?
    //var chartElement: [AASeriesElement] = []
    @IBOutlet var collectionView: UICollectionView!
    

    
    @objc func receiveObject(_ notification: NSNotification) {
        
        guard let object = notification.object as? MonetaryAccount else {return}
        destinationAccount = object
        lineChartDefinition = [] // Обнуляет массив после смены карты
        //Надо подумать как сделать так, чтобы добавление в чарт елемент не происходили постоянно при смене карты /// --- выполнено!
        monthTransactions(account: destinationAccount!)
        collectionView.reloadData()
    }
    
    func layout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        //layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        layout.minimumInteritemSpacing = 22
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 22 * 2
        layout.itemSize = CGSize(width: self.view.bounds.width - 22*2, height: self.collectionView.bounds.height)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = layout
    }
    
    func setupCollectionView(){
        
        let xib = UINib(nibName: "LineChartCell", bundle: nil)
        self.collectionView.register(xib, forCellWithReuseIdentifier: "LineChartIdentifier")
        self.collectionView.layer.masksToBounds = false
        self.collectionView.clipsToBounds = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.setColors()
        
        
      
        collectionView.delegate = self
        collectionView.dataSource = self
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveObject(_:)), name: NSNotification.Name(rawValue: "ContainerObject"), object: nil)
        setupCollectionView()
    }
}
extension LineChartContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = collectionView.visibleCells.first as? LineChartCell else {return}
        cell.prepareForReuse() // в функции prepareForReuse происходит удаление entryView
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LineChartCell else {return}
        cell.prepareForReuse()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lineChartDefinition.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LineChartIdentifier", for: indexPath) as! LineChartCell
        cell.contentView.backgroundColor = .clear
       // let object = chartElement[indexPath.row]
        let object = lineChartDefinition[indexPath.row]
        if indexPath.row == lineChartDefinition.count - 1 && lineChartDefinition.count > 1 {
            print("previous")
            cell.showAndHideNavigationImages(navigation: .previous)
        } else if indexPath.row == 0 && lineChartDefinition.count > 1 {
            print("next")
            cell.showAndHideNavigationImages(navigation: .next)
        } else if indexPath.row > 0 && indexPath.row < lineChartDefinition.count - 1 {
            cell.showAndHideNavigationImages(navigation: .all)
            print("all")
        } else {
            print("none")
            cell.showAndHideNavigationImages(navigation: .none)
        }
        cell.set(element: object)
       // cell.set(element: [chartElement[indexPath.item]]) // В этой функции есть возможность вывести textView при отсутствии елементов
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
        guard accountHistory.first?.date != nil else {
            
            lineChartDefinition.append(LineChartDataModel(chartDataSet: LineChartDataSet(label: "ArrayIsEmpty") , date: Date(), account: destinationAccount!))
        return} // Обнулить chartElement чтобы в collection cell можно было вывести textView c отсутствием транзакций
        let firstDate = accountHistory.first!.date
        let endDate = accountHistory.last!.date
        valuesFromInterval(firstDate: firstDate, endDate: endDate, accountHistory: accountHistory)
    }
    
    func valuesFromInterval(firstDate:Date, endDate: Date, accountHistory: [historyStructModel]) {
        lineChartDefinition = []
       // chartElement = [] // Как то так. Обнулил при запуске функции чтобы не было бесконечного добавления
        
        var enumeratedNumbers: [ChartDataEntry] = []
        
        var x: Double = 0 // Сдвиг по горизонтали
        var startDate = firstDate
        let endDate = endDate // end date в последствии скорее всего придется переименовать в today, чтобы заполнить пропущенные дни
        var calendar = Calendar.current
        var currentDate: Date = Date()
        var components = calendar.dateComponents([.month,.year], from: startDate)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        //Создание месячного графика
        while endDate > startDate.endOfMonth {  //
            let interval = DateInterval(start: startDate, end: startDate.endOfMonth)
            for i in accountHistory {
                if interval.contains(i.date){
                    enumeratedNumbers.append(ChartDataEntry(x: x, y: i.sum) )
                    x += 5
                    //--------------
                    currentDate = i.date
                }
            }
         
            //Если месяц не окончен
            switch enumeratedNumbers.count {
            case 0 :
                self.lineChartDefinition.append(LineChartDataModel(chartDataSet: LineChartDataSet(entries: enumeratedNumbers ,label: "ArrayIsEmpty"), date: currentDate, account: destinationAccount!))
                    //.append(LineChartDataSet(entries: enumeratedNumbers ,label: "ArrayIsEmpty"))
            case 1 :
                self.lineChartDefinition.append(LineChartDataModel.init(chartDataSet: LineChartDataSet(entries: enumeratedNumbers,label: "ArrayIsIncomplete"), date: currentDate, account: destinationAccount!))
                    //.chartDataSet.append(LineChartDataSet(entries: enumeratedNumbers ,label: "ArrayIsIncomplete"))
            default:
                self.lineChartDefinition.append(LineChartDataModel.init(chartDataSet: LineChartDataSet(entries: enumeratedNumbers), date: currentDate, account: destinationAccount!))
                
                
            }
            x = 0
            enumeratedNumbers.removeAll()
            components.month! += 1
            startDate = calendar.date(from: components)!
        }
        //создание последнего мемсца
        let interval = DateInterval(start: startDate, end: endDate)
        
        for i in accountHistory {
            if interval.contains(i.date) {
                enumeratedNumbers.append(ChartDataEntry(x: x, y: i.sum))
                x += 5
                currentDate = i.date
            }
        }
        switch enumeratedNumbers.count {
        case 0 :
            self.lineChartDefinition.append(LineChartDataModel(chartDataSet: LineChartDataSet(entries: enumeratedNumbers ,label: "ArrayIsEmpty"), date: currentDate, account: destinationAccount!))
        case 1 :
            self.lineChartDefinition.append(LineChartDataModel.init(chartDataSet: LineChartDataSet(entries: enumeratedNumbers,label: "ArrayIsIncomplete"), date: currentDate, account: destinationAccount!))
        default:
            self.lineChartDefinition.append(LineChartDataModel.init(chartDataSet: LineChartDataSet(entries: enumeratedNumbers), date: currentDate, account: destinationAccount!))
        }
    }
}

    
    

