//
//  TotalBalanceSchedulerViewController.swift
//  CashApp
//
//  Created by Артур on 9/29/20.
//  Copyright © 2020 Артур. All rights reserved.
//

import UIKit
import FSCalendar

class AccountsDetailViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource{
    
    @IBOutlet var schedule: UIView!
    @IBOutlet var boxView: UIView!
    @IBOutlet var calendarView: FSCalendar!
    
    let shapLayer = CAShapeLayer()
    var entityModel: MonetaryAccount?
    
    func checkType(){
        switch entityModel?.stringAccountType {
        case .box:
            calendarView.isHidden = true
            schedule.isHidden = true
            ///Box View
            boxView.isHidden = false
        case .cash :
            schedule.isHidden = true
            boxView.isHidden = true
            
            calendarView.isHidden = false
        case .card :
            calendarView.isHidden = true
            boxView.isHidden = true
            
            schedule.isHidden = false
            
        default:
            break
        }
    }
    
    @IBOutlet var upperButton: UIButton!
    ///Unused
    @IBOutlet var editImage: UIImageView!
    @IBOutlet var balanceLabel: UILabel!
    
    ///Used
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    
    ///Buttons
    @IBOutlet var upperButtonImage: UIImageView!
    @IBOutlet var middleButtonImage: UIImageView!
    @IBOutlet var lowerButtonImage: UIImageView!
    
    @IBOutlet var totalBalanceElementView: UIView!

    
    
 
  
    
    override func viewDidAppear(_ animated: Bool) {
        scrolToDate()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        upperButtonImage.setImageShadow(image: upperButtonImage)
        upperButtonImage.setImageShadow(image: middleButtonImage)
        upperButtonImage.setImageShadow(image: lowerButtonImage)
       
        lowerButtonImage.changePngColorTo(color: whiteThemeMainText)
        
        upperButton.setTitle("Done!", for: .normal)
        calendarView.changeColorTheme(Calendar: calendarView)
        
        headerLabel.text = entityModel?.name
        sumLabel.text = String(entityModel!.balance.currencyFR)
        
        navigationItem.title = entityModel?.initType()
        checkType()
        self.view.backgroundColor = whiteThemeBackground
        
        
        
    }
    func scrolToDate(){
        guard let dates = entityModel?.date else {return}
        calendarView.select(dates, scrollToDate: true)
        
    }
    
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendarView.setScope(.week, animated: true)
        
        
    }
    
    
    ///сделать тут чтонбудь
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Card" {
            let cardVC = segue.destination as! CardViewController
            cardVC.scheduleModel = entityModel
            
        }
        
        if segue.identifier == "Box" {
            let boxVC = segue.destination as! BoxViewController
            boxVC.boxModel = entityModel
        }
        }
    }

