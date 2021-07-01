//
//  CalendarSchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 26.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import FSCalendar
class CalendarSchedulerViewController: UIViewController {

    @IBOutlet var calendarView: FSCalendarView!
    @IBOutlet var closeButton: UIBarButtonItem!
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var datesArray = [Date]()
    var quickPayVC: UIViewController!
    
   
    
    func updateDatesArray() ->[Date]  {
        let datesArray: [Date] = {
            var dates = [Date]()
            for i in payPerTimeObjects{
                dates.append(i.date)
                
            }
            for x in Array(oneTimeObjects) {
                dates.append(x.date!)
            }
            for y in Array(goalObjects) {
                dates.append(y.date!)
            }
            return dates
        }()
        return datesArray
    }
    
    func createCalendar(){

        
        calendarView.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
    }

    func createObjectsArray(date: Date) -> [Any] {
        var objectsArray = [Any]()
        for i in payPerTimeObjects{
            if i.date == date {
            objectsArray.append(i)
            }
        }
        for x in Array(oneTimeObjects) {
            if x.date == date {
            objectsArray.append(x)
            }
        }
        for y in Array(goalObjects) {
            if y.date == date{
            objectsArray.append(y)
            }
        }
        return objectsArray
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.reloadData()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        datesArray = updateDatesArray()
        
        // Do any additional setup after loading the view.
    }
}

//MARK: CalendarDelegateDataSource / appearance
extension CalendarSchedulerViewController: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
        let anyArray = createObjectsArray(date: date) // Воспользовался функцией сверху (тут разовый, регулярный платеж и платеж в раз)
        
        guard !anyArray.isEmpty else {return}
        for i in datesArray {
            if date == i {
                goToSelectDateVC(delegateController: self, payObject: anyArray, sourseView: calendar.cell(for: date, at: monthPosition)!)
            }
            
        }
       
            
    }
   
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let a = uniq(source: datesArray)
        if a.contains(date) {
            return a.count + 1
        }else{
            return 0
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        for i in self.datesArray {
            if date == i {
                return .systemPink
            }
            }
        return nil
        }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        
        
        if datesArray.contains(date) {
            return 0.5
        }
        return 0.5
    
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        for i in self.datesArray {
            if date == i {
            return .white
            }
        }
        return nil
    }
    
    
}
extension CalendarSchedulerViewController : UIPopoverPresentationControllerDelegate{

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


//Закрывает поп ап меню, обновляет данные, закрывает анимацию
extension CalendarSchedulerViewController: closeSelectDateProtocol, QuickPayCloseProtocol {
    
    //close mini table view in calendar and view the blur
    func closeSelectDate(payObject: Any) {
        
//        guard blur.alpha != 1 else {return}
//        self.view.animateViewWithBlur(animatedView: blur, parentView: self.view)
        goToQuickPayVC(delegateController: self, classViewController: &quickPayVC, PayObject: payObject)
        
    }
    //close quicl pay and reload data in calendar and hide blur
    func closePopUpMenu() {
       // self.view.reservedAnimateView2(animatedView: blur)
        self.view.reservedAnimateView(animatedView: quickPayVC.view, viewController: nil)
        self.quickPayVC = nil
        datesArray = updateDatesArray()
        //tableView.reloadData()
        calendarView.collectionView.reloadData()
        calendarView.reloadData()
    }
    

    
    
}

