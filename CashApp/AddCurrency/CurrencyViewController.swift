//
//  AddCurrencyViewController.swift
//  CashApp
//
//  Created by Артур on 4.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    
    @IBOutlet var mainCurrencyOutlet: UIButton!
    @IBAction func mainCurrencyAction(_ sender: Any) {
        
        self.view.animateViewWithBlur(animatedView: tableView, parentView: self.view)
    }
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .gray
        tableView.layer.cornerRadius = 14
        
        return tableView
    }()
    
    var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 14
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.6)
        tabBarController?.tabBar.hideTabBar()
        self.view.backgroundColor = .systemGray5
        
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "currencyCell")
        
        buttonSettings()
    }
    
    func buttonSettings(){
        mainCurrencyOutlet.backgroundColor = .white
        mainCurrencyOutlet.setTitle("USD", for: .normal)
        mainCurrencyOutlet.layer.cornerRadius = 12
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.showTabBar()
    }
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        
        return cell
    }
    
    
    
    
}

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet var currencyImage: UIImageView!
    @IBOutlet var ISOLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
