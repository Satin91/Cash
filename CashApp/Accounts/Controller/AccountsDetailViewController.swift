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

    @IBOutlet var accountImage: UIImageView!
    
    var upperButtonName = "Remittance"
    var middleButtonName = "Top up"
    var bottomButtonName = "Delete"
        
    let shapLayer = CAShapeLayer()
    var entityModel: MonetaryAccount?
    let image = UIImageView()
 
    //Buttons outlets
    @IBOutlet var upperButton: UIButton!
    @IBOutlet var middleButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    ///Unused
    @IBOutlet var editImage: UIImageView!
    @IBOutlet var balanceLabel: UILabel!
    
    ///Used
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!
    
    ///Buttons images
    @IBOutlet var upperButtonImage: UIImageView!
    @IBOutlet var middleButtonImage: UIImageView!
    @IBOutlet var bottomButtonImage: UIImageView!
    
    @IBOutlet var totalBalanceElementView: UIView!

    
    
 
  
    
    override func viewDidAppear(_ animated: Bool) {
        scrolToDate()
        
    }
    

 
    func namesForButtons(){
        upperButton.setTitle(upperButtonName, for: .normal)
        middleButton.setTitle(middleButtonName, for: .normal)
        bottomButton.setTitle(bottomButtonName, for: .normal)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        namesForButtons()
        shadowForImage()
        bottomButtonImage.changePngColorTo(color: whiteThemeMainText)
        calendarView.changeColorTheme(Calendar: calendarView)
        headerLabel.text = entityModel?.name
        sumLabel.text = String(entityModel!.balance.currencyFR)
        //accountImage.image = UIImage(data: entityModel!.imageForAccount!)
        navigationItem.title = entityModel?.initType()
        checkType()
        self.view.backgroundColor = whiteThemeBackground
        setLabelShadows()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        totalBalanceElementView.setShadow(view: totalBalanceElementView, size: CGSize(width: 2, height: 2), opacity: 0.6, radius: 3, color: whiteThemeShadowText.cgColor)
        image.frame = CGRect(x: 0, y: 0, width: totalBalanceElementView.bounds.width, height:totalBalanceElementView.bounds.height )
        image.image = UIImage(data: (entityModel?.imageForAccount)!)
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        totalBalanceElementView.insertSubview(image, at: 1)
    }
    
    func setLabelShadows() {
        guard upperButton.titleLabel?.text != nil, middleButton.titleLabel?.text != nil, bottomButton.titleLabel?.text != nil else {return}
        for i in [upperButton.titleLabel!, middleButton.titleLabel!, bottomButton.titleLabel!] {
            i.setLabelSmallShadow(label: i)
        }
    }
    
    fileprivate func shadowForImage() {
        upperButtonImage.setImageShadow(image: upperButtonImage)
        upperButtonImage.setImageShadow(image: middleButtonImage)
        upperButtonImage.setImageShadow(image: bottomButtonImage)
    }
    func scrolToDate(){
        guard let dates = entityModel?.date else {return}
        calendarView.select(dates, scrollToDate: true)
    }
    func checkType(){
        switch entityModel?.stringAccountType {
        case .box:
            calendarView.isHidden = true
            schedule.isHidden = true
            //BoxView
            boxView.isHidden = false
        case .cash :
            
            schedule.isHidden = true
            boxView.isHidden = true
            //CalendarView
            calendarView.isHidden = false
        case .card :
            calendarView.isHidden = true
            boxView.isHidden = true
            //CalendarView
            schedule.isHidden = false
        default:
            break
        }
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

