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

extension NumpadView {
    private func theme(_ theme: MyTheme) {
        
    }
}

class NumpadView: UIInputViewController {

    lazy var backgroundcolor:UIColor = .clear
    lazy var shadowColor:UIColor = .clear
    lazy var secondaryBackground:UIColor = .clear
    
    let colors = AppColors()
    
    
    @IBOutlet var accountsButton: UIButton!
    @IBAction func accountsButtonAction(_ sender: UIButton) {
        sender.scaleButtonAnimation()
        delegateAction.scrollAndBackspace(action: "Accounts")
    }
    @IBOutlet var calendarButton: UIButton!
    @IBAction func calendarButtonAction(_ sender: UIButton) {
        sender.scaleButtonAnimation()
        delegateAction.scrollAndBackspace(action: "Calendar")
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        sender.scaleButtonAnimation()
        delegateAction.scrollAndBackspace(action: "Backspace")
    }
    
    @IBAction func save(_ sender: UIButton) {
        sender.scaleButtonAnimation()
        delegateAction.scrollAndBackspace(action: "Save")
    }
    @IBOutlet var zeroWidthConstraint: NSLayoutConstraint!
    @IBOutlet var dotWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let spacing = self.view.bounds.width * 0.04
        allStackViewSettings(spacing: spacing)
        zeroWidthConstraint.constant = (self.view.frame.width / 2) - (12 / 2)
        dotWidthConstraint.constant = allButtons[0].bounds.width
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
        let proxy = textDocumentProxy
        proxy.insertText(sender.titleLabel!.text!)
        sender.scaleButtonAnimation()
    }
   
    
    let backspaceImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "numpad.backspace")
        image.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return image
    }()
    let accountsImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "numpad.accounts")
        image.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return image
    }()
    let calendarImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "numpad.calendar")
        image.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        return image
    }()
    let checkmarkImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "numpad.checkmark")
        image.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
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
            btn.layer.setSmallShadow(color: ThemeManager2.currentTheme().shadowColor)
            btn.setTitleColor(ThemeManager2.currentTheme().subtitleTextColor, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
            btn.backgroundColor = colors.secondaryBackgroundColor.withAlphaComponent(0.6)
            btn.layer.borderWidth = 0.7
            btn.layer.borderColor = colors.borderColor.cgColor
         
            switch btn.tag {
            case 21:
                btn.setImage(backspaceImage.image, for: .normal)
                
                btn.setImageTintColor(colors.titleTextColor, imageName: "numpad.backspace")
                btn.contentMode = .scaleAspectFit
            case 22:
                btn.setImage(calendarImage.image, for: .normal)
                btn.setImageTintColor(colors.titleTextColor, imageName: "numpad.calendar")
            case 23:
                btn.setImage(accountsImage.image, for: .normal)
                btn.setImageTintColor(colors.titleTextColor, imageName: "numpad.accounts")
            case 24:
                btn.titleLabel?.isHidden = true
                btn.setImage(checkmarkImage.image, for: .normal)
                btn.setImageTintColor(colors.whiteColor, imageName: "numpad.checkmark")
                btn.backgroundColor = colors.contrastColor1
            default:
                break
            }
        }
   
        
        self.contentView.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNib()
        colors.loadColors()
        allButtonSettings()
    }
//    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
//        super.init(frame: frame, inputViewStyle: inputViewStyle)
//        loadNib()
//        colors.loadColors()
//        allButtonSettings()
//    }
//      required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        loadNib()
//      }
      private func loadNib() {
        let view = Bundle.main.loadNibNamed("NumpadView", owner: self, options: nil)![0] as! UIView
          view.frame = self.view.bounds
          self.view.addSubview(view)
        }
      
    
}
