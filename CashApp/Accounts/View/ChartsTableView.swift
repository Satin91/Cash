//
//  ChartsTableView.swift
//  
//
//  Created by Артур on 4.02.21.
//

import UIKit



class ChartsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
    
    var collectionView: LineChartCollectionViewController!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        //collectionView.view.frame = self.frame
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.register(UITableViewCell.self, forCellReuseIdentifier: "FirstCell")
        self.register(UITableViewCell.self, forCellReuseIdentifier: "SecondCell")
        self.isPagingEnabled = true
        
        
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.frame.height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath)
            collectionView = LineChartCollectionViewController(collectionViewLayout: LineChartCollectionViewController.layout)
            collectionView.view.frame = cell.contentView.bounds
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.contentView.addSubview(collectionView.view)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"SecondCell", for: indexPath)
            cell.textLabel?.text = "Second cell"
            cell.textLabel?.textColor = .darkGray
            cell.backgroundColor = .gray
            return cell
        }
    }
    
    
}
