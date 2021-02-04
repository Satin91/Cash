//
//  ChartsTableView.swift
//  
//
//  Created by Артур on 4.02.21.
//

import UIKit



class ChartsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var collectionView: ChartsCollectionView!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
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
            //let cell = tableView.dequeueReusableCell(withIdentifier: FirstChartsTableViewCell.identifier, for: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath)
            collectionView = ChartsCollectionView(frame: cell.contentView.bounds, collectionViewLayout: ChartsCollectionView.layout)
            collectionView.frame = cell.contentView.bounds
            cell.contentView.addSubview(collectionView)
            cell.backgroundColor = .clear
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"SecondCell", for: indexPath)
            cell.backgroundColor = .black
            return cell
        }
    }
    
    
}
