//
//  SchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 4.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class SchedulerViewController: UIViewController {

    
    @IBOutlet var calendarBackground: UIView!
    @IBOutlet var tableView: UITableView!
    var calendar = FSCalendarView()
    
    
    @IBAction func addButton(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
        installTableView()
        
        
    }
    
    func installTableView() {
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MainIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func createCalendar(){
        calendarBackground.addSubview(calendar)
        initConstraints(view: calendar, to: calendarBackground)
    }

  

}

extension SchedulerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedSchedulers(object: schedulerGroup).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainIdentifier", for: indexPath) as! MainTableViewCell
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        cell.set(monetaryObject: object)
        
        return cell
    }
    
    
    
    
}
