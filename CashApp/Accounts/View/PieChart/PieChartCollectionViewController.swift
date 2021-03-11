//
//  ChartsCollectionView.swift
//
//
//  Created by Артур on 4.02.21.
//

import UIKit
import AAInfographics
import RealmSwift

class PieChartCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    
    
   
    
    

    var chartElement: [AASeriesElement] = []
    let currentAccount = ContainerViewController.destinationAccount

    
   
    let LineController = LineChartCollectionViewController()
    static var layout = UICollectionViewFlowLayout()
    var accountName: String = ""

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //monthTransactions(account: ContainerViewController.destinationAccount!)
        self.collectionView.register(PieChartCollectionViewCell.self, forCellWithReuseIdentifier: "PieChartViewCell")
        //self.collectionView.register(LineChartCollectionViewCell.self, forCellWithReuseIdentifier: "LineChartViewCell")
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .clear
        self.view.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(receiveIndex), name: NSNotification.Name(rawValue: "IndexItem"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.collectionView.scrollToItem(at: IndexPath(item: chartElement.count - 2, section: 0), at: .centeredHorizontally, animated: false)
    }
      
        
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reportIndex(notificationName: "IndexItem", collectionView: self.collectionView)
        }
    
    
  
    
    @objc func receiveIndex(notification: NSNotification) {
        let indexPath = notification.userInfo!["index"]
        self.collectionView.scrollToItem(at: indexPath as! IndexPath, at: .centeredHorizontally, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Is selected indexPath in collectionView = \(indexPath.row) class ChartsCollectionView")
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartElement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width , height: self.view.bounds.height )
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PieChartViewCell", for: indexPath) as! PieChartCollectionViewCell
        
        
        cell.set(element: [chartElement[indexPath.row]])
        cell.backgroundColor = .clear
       
        return cell
    }
    ///MARK: Date settings
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
            if x.accountIdentifier == account.accountID {
                accountHistory.append(historyStructModel(name: x.name, sum: x.sum, date: x.date!))
            }
        }
        accountHistory.sort {$0.date < $1.date}
        let firstDate = accountHistory.first!.date
        let endDate = accountHistory.last!.date
        valuesFromInterval(firstDate: firstDate, endDate: endDate, accountHistory: accountHistory)
        
        
    }
    func valuesFromInterval(firstDate:Date, endDate: Date, accountHistory: [historyStructModel]) {
       var enumeratedNumbers: [Double] = []
        var startDate = firstDate
        let endDate = endDate // end date в последствии скорее всего придется переименовать в today, чтобы заполнить пропущенные дни
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        var calendar = Calendar.current
        var components = calendar.dateComponents([.month,.year], from: startDate)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        while endDate > startDate.endOfMonth {
            let interval = DateInterval(start: startDate, end: startDate.endOfMonth)
            for i in accountHistory {
                if interval.contains(i.date){
                    enumeratedNumbers.append(i.sum)
                }
            }
            chartElement.append(AASeriesElement().name(formatter.string(from: startDate)).data(enumeratedNumbers))
            enumeratedNumbers.removeAll()
            components.month! += 1
            startDate = calendar.date(from: components)!
        }
        
        let interval = DateInterval(start: startDate, end: endDate)
        for x in accountHistory {
            if interval.contains(x.date) {
                enumeratedNumbers.append(x.sum)
            }
        }
        chartElement.append(AASeriesElement().name(formatter.string(from: startDate)).data(enumeratedNumbers))
    }
}


