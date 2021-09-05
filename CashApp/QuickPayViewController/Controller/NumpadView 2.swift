//
//  NumpadView.swift
//  CashApp
//
//  Created by Артур on 20.08.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

protocol TappedNumbers {
    func sendNumber(number: String)
}

protocol tappedButtons {
    func scrollAndBackspace(action: String)
}
class NumpadView: UIView {

   
    @IBOutlet var accountsButton: UIButton!
    @IBAction func accountsButtonAction(_ sender: Any) {
        delegateAction.scrollAndBackspace(action: "Accounts")
    }
    @IBOutlet var calendarButton: UIButton!
    @IBAction func calendarButtonAction(_ sender: Any) {
        delegateAction.scrollAndBackspace(action: "Calendar")
        
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        delegateAction.scrollAndBackspace(action: "Backspace")
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
    @IBOutlet var contentView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var allButtons: [UIButton]!
    var delegate: TappedNumbers!
    var delegateAction: tappedButtons!
  

    
    @IBAction func numbers(_ sender: UIButton) {
        delegate.sendNumber(number: sender.titleLabel!.text!)
        allButtons[sender.tag].backgroundColor =  UIColor(red: 208/255.0, green: 216/255.0, blue: 222/255.0, alpha: 1.0)
        //print([sender.tag])
        UIView.animate(withDuration: 0.4, delay: 0, options: .allowUserInteraction ) {
            self.allButtons[sender.tag].backgroundColor = UIColor(red: 208/255.0, green: 216/255.0, blue: 222/255.0, alpha: 0.0)
        }
    }
    
    
    
    
    func visualSettings() {
        allButtons.forEach { (btn) in
             btn.layer.cornerRadius = 12
            btn.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
            btn.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        }
        
        
        self.contentView.backgroundColor = .clear
    }
      override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        visualSettings()
        
      }

      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
      }
      private func loadNib() {
        let view = Bundle.main.loadNibNamed("NumpadView", owner: self, options: nil)![0] as! UIView
          view.frame = bounds
          addSubview(view)
        }
      
    
}
