//
//  BarChartViewController.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Charts



class BarChartViewController: UIViewController{
    let colors = AppColors()
    let barChartModelController = BarChartModelController()
    var barChartPersents: [Double]!
    var cancelButton: CancelButton!
    @IBOutlet var segmentedControl: HBSegmentedControl!
    
    @IBAction func segmentedControlAction(_ sender: HBSegmentedControl) {
        sender.changeSegmentWithAnimation(tableView: tableView, collectionView: nil, ChangeValue: &changeValue)
        
    }
    lazy var changeValue: Bool = false
    func setupTableView() {
        let nib = UINib(nibName: "BarChartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "barChartCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.layer.masksToBounds = true
    }
    @IBOutlet var tableView: UITableView!
   
    @objc func buttonTapped(_ sender: UIButton) {
        print("ANY")
        self.dismiss(animated: true, completion: nil)
    }
    func setupCancelButton() {
        let width:CGFloat = 90
        
        cancelButton = CancelButton(frame: CGRect(x: self.view.bounds.width - 22 - width, y: 26, width: width, height: 34) , title: .cancel, owner: self)
        self.view.insertSubview(cancelButton, at: 10)
        cancelButton.addTarget(self, action: #selector(BarChartViewController.buttonTapped(_:)), for: .touchUpInside)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.loadColors()
        self.setColors()
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        setupCancelButton()
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        
        
        title = "Chart"
        
        segmentedControl.changeValuesForCashApp(segmentOne:NSLocalizedString("segmented_control_0", comment: ""), segmentTwo: NSLocalizedString("segmented_control_1", comment: ""))
    }
    
}

extension BarChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let categoryType: CategoryType = changeValue ? .income : .expence
        let items = barChartModelController.getBarChartItems(categoryType: categoryType)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryType : CategoryType = changeValue ? .income : .expence
        let object = barChartModelController.getBarChartItems(categoryType: categoryType)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "barChartCell", for: indexPath) as! BarChartCell
        cell.set(object: object)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
