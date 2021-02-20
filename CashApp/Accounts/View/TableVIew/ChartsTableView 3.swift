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
        self.register(LineChartTableViewCell.self, forCellReuseIdentifier: "LineChartCell")
        self.register(PieChartTableViewCell.self, forCellReuseIdentifier: "PieChartCell")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "LineChartCell", for: indexPath)

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"PieChartCell", for: indexPath)

            return cell
        }
    }
    
    
}
