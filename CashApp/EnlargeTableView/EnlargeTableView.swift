//
//  EnlargeTableView.swift
//  CashApp
//
//  Created by Артур on 2.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


struct EnlargeHistoryModel{
    var date: Date
    var historyArray: [AccountsHistory]    
}

class EnlargeTableView: UITableView,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, SendEnlargeIndex {
    
    //MARK: Lets add buttons in header
    
    
    
    
    
    
    func enlarge(object: IndexPath) {
        ipath = object
        self.performBatchUpdates(nil, completion: nil)
    }
    func calculateHeightCell(enlargeCell: EnlargedCell) {
        let cell = enlargeCell
        var smallCellIndex = IndexPath()
        for i in cell.smallCell {
            smallCellIndex = i
        }
        //если ячейка была выбрана до этого
        if pairedCells.contains(where: { (Cell2) -> Bool in
            Cell2.largeCell == cell.largeCell
        }) {
            
            //Цикл для поиска нужного индекса в большой ячейке
            for (index,value) in pairedCells.enumerated() {
                //условия на соответствие
                if value.largeCell == cell.largeCell {
                    //если нажата маленькая ячейка повторно
                    if value.smallCell.contains(smallCellIndex) {
                        for (index2,value2) in value.smallCell.enumerated() {
                            if value2 == smallCellIndex {
                                //удалить
                                pairedCells[index].smallCell.remove(at: index2)
                            }
                        }
                    }else{
                        //если не нажата то добавить
                        pairedCells[index].smallCell.append(smallCellIndex)
                    }
                }
            }
        }else{
            //если большая ячейка не была нажата
            pairedCells.append(cell)
        }
        //Окончательная проверка на присутствие открытых ячеек в маленьком тейбл вью
        for (index,value) in pairedCells.enumerated() {
            if value.smallCell.count == 0 {
                pairedCells.remove(at: index)
            }
        }
    }
    
    var enlargeArray: [EnlargeHistoryModel] = []
//        willSet {
//            guard indexForDeletedRow != nil else {return}
//            print("CHTOTO")
//            if self.tag == 15888{
//            self.performBatchUpdates {
//                print(enlargeArray)
//                if self.enlargeArray[self.indexForDeletedRow!].historyArray == []{
//                    self.enlargeArray.remove(at: self.indexForDeletedRow!)
//                    self.deleteRows(at: [IndexPath(row: 0, section: 0) ], with: .fade)
//                    self.numberOfRows(inSection: enlargeArray.count)
//                    self.rowHeight = 0
//                }else{
//                guard enlargeArray[indexForDeletedRow!].historyArray.count != 0 else {return}
//                let object = enlargeArray[indexForDeletedRow!].historyArray.count * Int(smallCellHeight) + 50
//                for i in pairedCells {
//                    if i.largeCell == IndexPath(row: indexForDeletedRow!, section: 0) {
//                            self.rowHeight = CGFloat(object + i.smallCell.count * Int(enlargedSmallHeight - smallCellHeight))
//                    }
//                }
//                }
//            }completion: { (isTrue) in
//                print("reloadddada")
//                self.reloadData()
//            }
//            }
//        }
//    }
    var header: HeaderView? = nil
    var topBarHeight: CGFloat!
    let contentViewHeight: CGFloat = 254
    func getDates() {
        
    }
    ///MARK: Set data for history
    func enterHistoryData() {
        var date: Date? = historyObjects.first?.date
        guard date != nil else {return}
        var historyArray: [AccountsHistory] = []
        var enlargeObject = EnlargeHistoryModel(date: Date(), historyArray: historyArray)
        var counter = Int(0)
        var enlargeArray: [EnlargeHistoryModel] = []
        for (index,value) in historyObjects.enumerated() {
            //Начинает счет для того чтобы посчитать количество дат
            counter += 1
            let component = Calendar.current.dateComponents([.day,.month,.year], from: date!)
            //фильтрация массива по дате итеративного объекта, чтобы в дальнейшем можно было отменять добовление по количеству одинаковых дат
            let dateCount = historyObjects.filter({ (history) in
                let components = Calendar.current.dateComponents([.day,.month,.year], from: history.date)
               return components == component
            }).count
            //Добавляет дату в массив дат но пока не записывает его в большую ячейку
                historyArray.append(value)
            if counter == dateCount{
                //Записывает в большой массив дат и в последующем обнуляет счетчик и массив для следующей большой ячейки
                enlargeObject = EnlargeHistoryModel(date: value.date, historyArray: historyArray)
                enlargeArray.append(enlargeObject)
                //Я не понимаю почему, но рилм объекты нихера не могут вступать в контакт с обычными переменными если добовлять индекс, он как танк рубит и ошибку выдает
                let obj = Array(historyObjects)
                if obj.count == index + 1{
                    break
                }else {
                    date = obj[index + 1 ].date
                }
                    counter = 0
                    historyArray = []
                }
        }
        self.enlargeArray = enlargeArray
        self.reloadData()
    }
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
    }
    //MARK:                                      REQ INIT
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tag = 15888
        self.register(EnlargeTableViewCell.self, forCellReuseIdentifier: "EnlargeTableViewCell")
        self.tableFooterView = UIView()
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
        self.contentInset = UIEdgeInsets(top: contentViewHeight + Layout.top + 15, left: 0, bottom: 0, right: 0)
    }
    
    //TODO: SCROLL FUNC
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Сама высота вьюшки определяетя отступом инсета у table view
        let heightInCollapse: CGFloat = 80
        let y = -scrollView.contentOffset.y
        let height = max(y, heightInCollapse)
        var persent: CGFloat = 0
        //200 это инсет у тейбл вью
        let const: CGFloat = 200 - heightInCollapse
        persent = (height - heightInCollapse)/const
        let sidePoint: CGFloat = 0.26
        let radiusPoint: CGFloat = 0.35
        //расстоянние до стенок
        var sideDistance = Layout.side
        var radius: CGFloat = 35
        if persent * sidePoint*100 <= 26 {
            sideDistance = persent * sidePoint*100
        }
        if persent * radiusPoint*100 <= 35 {
            radius = persent * radiusPoint*100
        }
        if y < contentViewHeight {
            header?.HideButtons()
        }else{
            header?.showButtons()
        }
        header?.view.layer.cornerRadius = radius
        header?.view.frame = CGRect(x: sideDistance , y: topBarHeight + Layout.top, width: self.bounds.width - (sideDistance ) * 2, height: height - 15)
        header?.view.center.x = self.center.x
        
        //get and print date
        guard enlargeArray.count > 0 else {return}
        guard let firstIndexPath = self.indexPathsForVisibleRows?.first else {return}
        let object = enlargeArray[firstIndexPath.row].date
        
        header?.dateLabel.text = dateToString(date: object)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 15888 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnlargeTableViewCell", for: indexPath) as! EnlargeTableViewCell
            let object = enlargeArray[indexPath.row]
            cell.selectionStyle = .none
            cell.dateLabel.text = dateToString(date: object.date)
            
            return cell
        }else{
            if tableView.tag == tableView.tag {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! SecondTableViewCell
                let object = enlargeArray[tableView.tag]
                cell2.selectionStyle = .none
                if indexPath.row == object.historyArray.count - 1 {
                    cell2.set(object: object.historyArray[indexPath.row], isLast: true)
                    cell2.delegate = self
                    cell2.image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
                    return cell2
                }else{
                    cell2.set(object: object.historyArray[indexPath.row], isLast: false)
                    cell2.image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
                    cell2.delegate = self
                    return cell2
                }
                
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EnlargeTableViewCell else {return}
        cell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
        if tableView.tag != 15888{
            
        }
        
    }
    
    
    var pairedCells = [EnlargedCell]()
    var ipath: IndexPath?
    var selectedIndexPath: [IndexPath] = []
    var minHeight: Int = 0
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == tableView.tag {
            var cell = EnlargedCell(tag: tableView.tag)
            cell.smallCell.append(indexPath)
            cell.largeCell = ipath
            calculateHeightCell(enlargeCell: cell)
            tableView.performBatchUpdates(nil, completion: nil)
        }else if tableView.tag == 15888 {
            tableView.performBatchUpdates(nil, completion: nil)
        }
        self.performBatchUpdates(nil, completion: nil)
    }
    
    lazy var enlargedSmallHeight: CGFloat = 120
    lazy var smallCellHeight: CGFloat = 80
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag != 15888{
            for i in pairedCells {
                if tableView.tag == i.tag {
                    if i.smallCell.contains(indexPath){
                        return enlargedSmallHeight
                    }
                }
                
            }
            return smallCellHeight
        }  //else tableView.tag == 15888
        let object = enlargeArray[indexPath.row].historyArray.count * Int(smallCellHeight) + 50
        if tableView.tag == 15888{
            // если присутствует нажатая ячейка
            for i in pairedCells {
                if i.largeCell == indexPath {
                    return CGFloat(object + i.smallCell.count * Int(enlargedSmallHeight - smallCellHeight))
                }
            }
            return CGFloat(object)
        }
        return UITableView.automaticDimension
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag != 15888 {
            return enlargeArray[tableView.tag].historyArray.count
        }else{
            return enlargeArray.count
        }
    }
    func findTheAccountIn(accountID: String, historyObject: AccountsHistory){
        var account: MonetaryAccount?
        
        for i in accountsObjects {
            if accountID == i.accountID{
            account = i
            }
        }
        try! realm.write {
        guard let acc = account else {
            realm.delete(historyObject)
            return
        }
            acc.balance -= historyObject.sum
            realm.add(acc,update: .all)
            realm.delete(historyObject)
        }
    }
   
    var indexForDeletedRow: Int? {
        willSet {
            guard let nV = newValue else {return}
            if self.tag == 15888{
                self.performBatchUpdates {
                    if enlargeArray[nV].historyArray.isEmpty == true {
                    self.enlargeArray.remove(at: nV )
                    //self.numberOfRows(inSection: 0)
                    self.deleteRows(at: [IndexPath(row: nV, section: 0)], with: .bottom)
                    }
                } completion: { _ in
                    self.reloadData()
                }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        //Запрещает использовать иной tableView
        if tableView.tag != 15888 {
            
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            
                let object = self.enlargeArray[tableView.tag].historyArray[indexPath.row]
                self.enlargeArray[tableView.tag].historyArray.remove(at: indexPath.row)
                self.findTheAccountIn(accountID: object.accountID, historyObject: object)
                tableView.deleteRows(at: [indexPath], with: .left)
            
            self.indexForDeletedRow = tableView.tag
            
            
            complete(true)
        }
        deleteAction.backgroundColor = ThemeManager.currentTheme().contrastColor2
        let image = UIImageView()
        image.image = UIImage(systemName: "trash")
        image.tintColor = ThemeManager.currentTheme().titleTextColor
        deleteAction.image = image.image
      
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
        }else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in
            //self.Items.remove(at: indexPath.row)
            // self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    
    
}


struct EnlargedCell {
    var largeCell: IndexPath? = nil
    var smallCell: [IndexPath] = []
    var tag: Int
}

