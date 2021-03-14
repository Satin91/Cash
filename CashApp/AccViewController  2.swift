//
//  AccViewController.swift
//  CashApp
//
//  Created by Артур on 8/27/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit

class AccViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var TableViewContainer: UITableView!
    
    @IBOutlet var NMV: NeomorphicView!
    @IBAction func AccViewSegmentedControl(_ sender: HBSegmentedControl) {
        switch sender.selectedIndex {
        case 0:
            print("kek")
        default:
            break
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewContainer.delegate = self
        TableViewContainer.dataSource = self
        TableViewContainer.rowHeight = 90
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsCash.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeinTableViewCell.accIdentifier) as! MeinTableViewCell
        let object = accountsCash[indexPath.row]
        cell.accSetCash(object: object)
        cell.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        tableView.backgroundView?.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return cell
    }
    
    
    
    
}
