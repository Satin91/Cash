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
    @IBOutlet var zeroWidthConstraint: NSLayoutConstraint!
    @IBOutlet var dotWidthConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let spacing = self.bounds.width * 0.04
        allStackViewSettings(spacing: spacing)
        zeroWidthConstraint.constant = (self.frame.width / 2) - (12 / 2)
        dotWidthConstraint.constant = allButtons[0].bounds.width
        
        
        //allButtons[0].frame.width * 2
    }
    @IBAction func saveButton(_ sender: UIButton) {
    }
    @IBOutlet var contentView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet var allStackView: [UIStackView]!
    var delegate: TappedNumbers!
    var delegateAction: tappedButtons!
  
    
    
    @IBAction func numbers(_ sender: UIButton) {
        delegate.sendNumber(number: sender.titleLabel!.text!)
        //sender.backgroundColor =  ThemeManager.currentTheme().borderColor
        sender.scaleButtonAnimation()
//        UIView.animate(withDuration: 0.4, delay: 0, options: .allowUserInteraction ) {
//            self.allButtons[sender.tag].backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
//        }
    }
   
    
    let backspaceImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "backspace")
        image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
        return image
    }()
    let accountsImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "accounts")
        image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
        return image
    }()
    let calendarImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "calendar")
        image.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
        return image
    }()
    
    func allStackViewSettings(spacing: CGFloat) {
        allStackView.forEach { (stView) in
            stView.spacing = spacing
        }
    }
    
    func allButtonSettings() {
        
        allButtons.forEach { (btn) in
            btn.layer.cornerRadius = 12
            btn.layer.setSmallShadow(color: ThemeManager.currentTheme().shadowColor)
            btn.setTitleColor(ThemeManager.currentTheme().subtitleTextColor, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
            btn.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
            btn.layer.borderWidth = 1
            btn.layer.borderColor = ThemeManager.currentTheme().borderColor.cgColor
         
            switch btn.tag {
            case 21:
                btn.setImage(backspaceImage.image, for: .normal)
                btn.setImageTintColor(ThemeManager.currentTheme().titleTextColor)
                btn.contentMode = .scaleAspectFit
            case 22:
                btn.setImage(accountsImage.image, for: .normal)
                btn.setImageTintColor(ThemeManager.currentTheme().titleTextColor)
            case 23:
                btn.setImage(calendarImage.image, for: .normal)
                btn.setImageTintColor(ThemeManager.currentTheme().titleTextColor)
            default:
                break
            }
        }
   
        
        self.contentView.backgroundColor = .clear
    }
      override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        allButtonSettings()
        
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
