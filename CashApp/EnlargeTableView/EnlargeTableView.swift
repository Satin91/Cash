//
//  EnlargeTableView.swift
//  CashApp
//
//  Created by Артур on 2.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


struct EnlargeHistoryObject{
    var date: Date
    var historyArray: [AccountsHistory]    
}

class EnlargeTableView: UITableView,UITableViewDelegate,UITableViewDataSource, SendEnlargeIndex {

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
    var enlargeArray: [EnlargeHistoryObject] = []
    
    
///MARK: Set data for history
    func enterHistoryData() {
        var date: Date? = historyObjects.first?.date
        guard date != nil else {return}
        var historyArray: [AccountsHistory] = []
        var enlargeObject = EnlargeHistoryObject(date: Date(), historyArray: historyArray)
        var counter = Int(0)
        var enlargeArray: [EnlargeHistoryObject] = []
        for i in historyObjects {
            counter += 1
            let component = Calendar.current.dateComponents([.day,.month,.year], from: date!)
            let comp = Calendar.current.dateComponents([.day,.month,.year], from: i.date)
            if comp == component  {
                //historyTemplate = i
                historyArray.append(i)
                if counter == historyObjects.count {
                    enlargeObject = EnlargeHistoryObject(date: date!, historyArray: historyArray)
                    enlargeArray.append(enlargeObject)
                }
            }else{
                guard historyArray.isEmpty == false else {return}
                enlargeObject = EnlargeHistoryObject(date: date!, historyArray: historyArray)
                enlargeArray.append(enlargeObject)
                historyArray = []
                //Добавил в массив первый объект который не соответствует прошлой дате, в противном случае цикл просто его пропустит
                historyArray.append(i)
                date = i.date
            }
            self.enlargeArray = enlargeArray
            self.reloadData()
       
        }
        
        
    }
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tag = 15888
        self.register(EnlargeTableViewCell.self, forCellReuseIdentifier: "EnlargeTableViewCell")
        self.tableFooterView = UIView()
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 15888 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnlargeTableViewCell", for: indexPath) as! EnlargeTableViewCell
            let object = enlargeArray[indexPath.row]
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
                    return cell2
                }else{
                cell2.set(object: object.historyArray[indexPath.row], isLast: false)
                    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag != 15888{
            for i in pairedCells {
                if tableView.tag == i.tag {
                    if i.smallCell.contains(indexPath){
                        return 100
                    }
                }
                
            }
            return 60
        }  //else tableView.tag == 15888
        let object = enlargeArray[indexPath.row].historyArray.count * 60 + 50
        if tableView.tag == 15888{
            // если присутствует нажатая ячейка
            for i in pairedCells {
                if i.largeCell == indexPath {
                    return CGFloat(object + i.smallCell.count * 40)
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
}


struct EnlargedCell {
    var largeCell: IndexPath? = nil
    var smallCell: [IndexPath] = []
    var tag: Int
}

