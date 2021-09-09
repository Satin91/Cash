//
//  SchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 4.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
import SwipeCellKit

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
        //создание попап вьюшки
        let navVC = UINavigationController(rootViewController: addScheduleVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet var tableView: UITableView!
    
    var quickPayVC = QuickPayViewController()
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
    
    func visualSettings() {
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.navigationItem.title = NSLocalizedString("scheduler_navigation_title", comment: "")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlur()
        installTableView()
        setupNavigationController(Navigation: self.navigationController!)
        visualSettings()
        

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

//MARK: - TableView
extension SchedulerViewController: UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {
    
    func updateDataAfterRemove(indexPath: IndexPath) {
        let ar = EnumeratedSchedulers(object: schedulerGroup)
        if ar[indexPath.row].stringScheduleType == .multiply || ar[indexPath.row].stringScheduleType == .regular {
            print("соответствует")
            for i in payPerTimeObjects {
                if i.scheduleID == ar[indexPath.row].scheduleID {
                    print(i)
                    try! realm.write({
                        realm.delete(i)
                    })
                }
            }
        }
        try! realm.write({
            realm.delete(ar[indexPath.row])
        })
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        var a = EnumeratedSchedulers(object: schedulerGroup)
        let delete = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in
            tableView.performBatchUpdates {
                
                self.updateDataAfterRemove(indexPath: indexPath)
                a.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            } completion: { tr in
            }
        }
        let edit = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            
            let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addScheduleVC") as! AddScheduleViewController
            editVC.isEditingScheduler = true
            editVC.reloadParentTableViewDelegate = self
            editVC.newScheduleObject = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
            self.present(editVC, animated: true, completion: nil)
        }
        
        delete.backgroundColor = ThemeManager.currentTheme().contrastColor2
        edit.backgroundColor = ThemeManager.currentTheme().borderColor
        
        return [delete,edit]
    }
    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructiveAfterFill
//        options.transitionStyle = .drag
//        options.buttonSpacing = 4
//
//
//        return options
//    }
//
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        tableView.isEditing = false
    }
//
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        tableView.isEditing = false
    }
//
//    func visibleRect(for tableView: UITableView) -> CGRect? {
//        return CGRect(x: 0, y: 0, width: 50, height: 25)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EnumeratedSchedulers(object: schedulerGroup).count > 0 ? EnumeratedSchedulers(object: schedulerGroup).count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != EnumeratedSchedulers(object: schedulerGroup).count {
            return 155
        }else{
            return 97 + 12
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  indexPath.row == EnumeratedSchedulers(object: schedulerGroup).count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateIdentifier", for: indexPath) as! CreateScheduleCell
            cell.selectionStyle = .none
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleIdentifier", for: indexPath) as! SchedulerTableViewCell
        cell.delegate = self
        cell.sendSchedulerDelegate = self
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        cell.set(object: object)
        cell.selectionStyle = .blue
        return cell
        }
    }
   
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        //let object = scheduler
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
//            self.updateDataAfterRemove(indexPath: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        let editAction = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//
//        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
//        return actions
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row != EnumeratedSchedulers(object: schedulerGroup).count {
            showQuickPayDashboard(indexPath: indexPath)
        }else{
            goToSelectScheduleType()
        }
    }
    func goToSelectScheduleType() {
        let selectScheduleType = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectSchedulerType") as! SelectSchedulerTypeViewController
        selectScheduleType.reloadDelegate = self
        let navVC = UINavigationController(rootViewController: selectScheduleType)
        navVC.modalPresentationStyle = .popover
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    func showQuickPayDashboard(indexPath: IndexPath) {
        
        let object = EnumeratedSchedulers(object: schedulerGroup)[indexPath.row]
        //self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let QuiclPayVC = storyboard.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayViewController
        QuiclPayVC.modalPresentationStyle = .formSheet
        
        let pptObject: PayPerTime? = {
           var pptObjects = [PayPerTime]()
            for i in payPerTimeObjects {
                if i.scheduleID == object.scheduleID{
                    pptObjects.append(i)
                }
            }
            guard pptObjects.first != nil else {return nil}
          //  object = pptObjects
            return pptObjects.first!
        }()
        
        switch object.stringScheduleType {
        case .goal:
            QuiclPayVC.payObject = object
            self.addChildViewController(PayObject: object)
         //   goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        case .oneTime:
            
            self.addChildViewController(PayObject: object)
         //   goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
        case .multiply:
            guard pptObject != nil else {return}
            
            self.addChildViewController(PayObject: pptObject)
         //   goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: pptObject!)
        case .regular:
            guard pptObject != nil else {return}
            QuiclPayVC.payObject = pptObject
            self.addChildViewController(PayObject: pptObject)
            
           // goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: pptObject!)
        }
        
        
      
    }
}


extension SchedulerViewController: ClosePopUpTableViewProtocol,SendScheduleObjectToEdit {
   
    func sendObject(object: MonetaryScheduler) {
        let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addScheduleVC") as! AddScheduleViewController
        editVC.isEditingScheduler = true
        editVC.newScheduleObject = object
        editVC.reloadParentTableViewDelegate = self
        self.present(editVC, animated: true, completion: nil)
    }
    
    func closeTableView(object: Any) {
        guard blur.alpha != 1 else {return}
        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
       // goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: object)
    }
    
    func closePopUpMenu() {
        self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView(animatedView: quickPayVC.view, viewController: nil)
     //   self.quickPayVC = nil
        tableView.reloadData()
        
        
    }
}




