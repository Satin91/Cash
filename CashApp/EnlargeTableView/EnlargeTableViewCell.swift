//
//  EnlargeTableViewCell.swift
//  CashApp
//
//  Created by Артур on 2.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


class EnlargeTableViewCell: UITableViewCell{
 

    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.frame = .zero
        return label
    }()
    
    var tableView: UITableView!
    var tableViewContainer = UIView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
  
    func clearedBackGround() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    func commonInit() {
        tableView = UITableView(frame: .zero)
        self.contentView.addSubview(tableViewContainer)
     
        clearedBackGround()
        self.contentView.addSubview(tableView)
        self.contentView.addSubview(dateLabel)
        self.dateLabel.text = "DateLabel"
        self.contentView.layer.cornerRadius = 20
        miniTableViewSettings()
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        self.tableView.layer.masksToBounds = false
        self.tableView.clipsToBounds = false
       
        createConstraints()
    }
    
    func miniTableViewSettings() {
        
        tableView.tableFooterView = UIView()
        tableViewContainer.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        tableViewContainer.layer.cornerRadius = 20
        tableViewContainer.layer.masksToBounds = false
        tableViewContainer.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        //mini table view
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.register(SecondTableViewCell.self, forCellReuseIdentifier: "Cell2")
    }
    
    func createConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.contentView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0),
            self.contentView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0),
            self.contentView.topAnchor.constraint(equalTo: topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.side),
            tableViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -Layout.side),
            tableViewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            tableViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor,constant: 0),
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor,constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 800),
            dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: Layout.side),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
extension EnlargeTableViewCell {
    func setTableViewDataSourceDelegate<D: UITableViewDataSource & UITableViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        tableView.tag = row
        tableView.reloadData()
        }
}






