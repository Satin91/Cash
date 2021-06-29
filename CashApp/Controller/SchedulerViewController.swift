//
//  SchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 4.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar


class SchedulerViewController: UIViewController,dismissVC,ReloadParentTableView {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    func dismissVC(goingTo: String, typeIdentifier: String) {
        let addScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addScheduleVC") as! AddScheduleViewController
        if goingTo == "addScheduleVC" {
            switch typeIdentifier {
            case "One time":
                addScheduleVC.newScheduleObject.stringScheduleType = .oneTime
            case "Multiple":
                addScheduleVC.newScheduleObject.stringScheduleType = .multiply
            case "Regular":
                addScheduleVC.newScheduleObject.stringScheduleType = .regular
            case "Goal":
                addScheduleVC.newScheduleObject.stringScheduleType = .goal
            default:
                return
            }
        }
        //Назначение делегата на себя
        addScheduleVC.reloadParentTableView = self
        //создание попап вьюшки
        let navVC = UINavigationController(rootViewController: addScheduleVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet var tableView: UITableView!
    
    var quickPayVC: UIViewController!
    //Тут в принципе вызывается календарь
    @IBAction func addButton(_ sender: Any) {
        goToPickTypeVC(delegateController: self, buttonsNames: ["One time","Multiple","Regular","Goal"], goingTo: "addScheduleVC")
        
    }
    
    //Я ее напихал во все обновляющие функции т.к. календарь все время обновляется
    
  
 
    
    
    private func uniq<S: Sequence, T: Hashable> (source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]() // возвращаемый массив
        var added = Set<T>() // набор - уникальные значения
        var repeating = [T]()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }else{
                repeating.append(elem)
            }
        }
        return repeating
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBlur()
        installTableView()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    func installTableView() {
        //let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        //tableView.register(nib, forCellReuseIdentifier: "MainIdentifier")
        tableView.register(SchedulerTableViewCell.nib(), forCellReuseIdentifier: "ScheduleIdentifier")
        tableView.register(CreateScheduleCell.nib(), forCellReuseIdentifier: "CreateIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    func addBlur() {
        self.blur.frame = self.view.bounds
        self.blur.alpha = 0
        self.view.addSubview(blur)
    }

   

}

extension SchedulerViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedSchedulers(object: schedulerGroup).count > 0 ? EnumeratedSchedulers(object: schedulerGroup).count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != EnumeratedSchedulers(object: schedulerGroup).count {
            return 155
        }else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row == EnumeratedSchedulers(object: schedulerGroup).count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateIdentifier", for: indexPath) as! CreateScheduleCell
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleIdentifier", for: indexPath) as! SchedulerTableViewCell
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        cell.set(object: object)
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != EnumeratedSchedulers(object: schedulerGroup).count {
            showQuickPayDashboard(indexPath: indexPath)
        }else{
            goToPickTypeVC(delegateController: self, buttonsNames: ["One time","Multiple","Regular","Goal"], goingTo: "addScheduleVC")
        }
    }
    
    func showQuickPayDashboard(indexPath: IndexPath) {
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        let pptObject: PayPerTime? = {
           var pptObjects = [PayPerTime]()
            for i in payPerTimeObjects {
                if i.scheduleID == object.scheduleID{
                    pptObjects.append(i)
                }
            }
            guard pptObjects.first != nil else {return nil}
            return pptObjects.first!
        }()
        switch object.stringScheduleType {
        case .goal:
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        case .oneTime:
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        case .multiply:
            guard pptObject != nil else {return}
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: pptObject!)
        case .regular:
            guard pptObject != nil else {return}
            goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: pptObject!)
        }
    }
}

extension SchedulerViewController : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SchedulerViewController: closeSelectDateProtocol, QuickPayCloseProtocol {
    func closeSelectDate(payObject: Any) {
        guard blur.alpha != 1 else {return}
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: payObject)
        
    }
    
    func closePopUpMenu() {
        self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView(animatedView: quickPayVC.view, viewController: nil)
        self.quickPayVC = nil
        
        tableView.reloadData()
        
        
    }
    

    
    
}
