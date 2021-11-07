//
//  AlertViewController.swift
//  CashApp
//
//  Created by Артур on 8.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
enum AlertStyle {
    case delete
    case close
}

class AlertViewController: UIView {
    let colors = AppColors()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var alertImage: UIImageView!
    @IBOutlet var leftButtonOutlet: UIButton!
    @IBOutlet var rightButtonOutlet: UIButton!
    
    weak var controller: UIViewController!
    var alertStyle: AlertStyle?
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: Themer.shared.theme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colors.loadColors()
        visualSettings()
        
        //blur.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.insertSubview(blur, at: 0)
    }

    func visualSettings() {
        //blur
       // blur.frame = self.bounds
        //labels
        titleLabel.font = .systemFont(ofSize: 26, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = colors.titleTextColor
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        messageLabel.font = .systemFont(ofSize: 17, weight: .light)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = colors.subtitleTextColor
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        //buttons
        
        leftButtonOutlet.backgroundColor = colors.contrastColor1
        leftButtonOutlet.layer.cornerRadius = leftButtonOutlet.bounds.height / 4
        leftButtonOutlet.setTitleColor(colors.backgroundcolor, for: .normal)
        
        rightButtonOutlet.tintColor = colors.titleTextColor
        rightButtonOutlet.layer.borderWidth = 1
        rightButtonOutlet.layer.borderColor = colors.borderColor.cgColor
        rightButtonOutlet.layer.cornerRadius = leftButtonOutlet.bounds.height / 4
        
        alertImage.image = UIImage().myImageList(systemName: "trash.fill")
        alertImage.tintColor = colors.contrastColor1
        
        self.containerView.backgroundColor = colors.secondaryBackgroundColor
        self.containerView.layer.cornerRadius = 28
        self.containerView.layer.cornerCurve = .continuous
        self.containerView.layer.setMiddleShadow(color: colors.shadowColor)
        self.backgroundColor = .clear
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//            super.init(nibName: "AlertViewController", bundle: nil)
//
//        }
    
    @IBOutlet var containerView: UIView!
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
 
    func setAlertStyle(alertStyle: AlertStyle) {
        let deleteText = NSLocalizedString("common_delete_button", comment: "")
        let calcelText = NSLocalizedString("cancel_button", comment: "")
        
        switch alertStyle {
        case .close:
            leftButtonOutlet.setTitle("Close", for: .normal)
            rightButtonOutlet.setTitle("Cancel", for: .normal)
        case .delete:
            leftButtonOutlet.setTitle(deleteText, for: .normal)
            rightButtonOutlet.setTitle(calcelText, for: .normal)
        }
    }
    func closeAlert() {
        self.reservedAnimateView(animatedView: self, viewController: controller)
 
    }
    func showAlert( title: String, message: String, alertStyle: AlertStyle) {
        self.controller.view.isUserInteractionEnabled = false // чтобы нельзя было 100 раз нажать на вызов контроллера пока тото появляется
        self.alpha = 0
        self.blur.alpha = 0
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.setAlertStyle(alertStyle: alertStyle)
        self.frame = controller.view.bounds
        controller.view.addSubview(self)
        self.containerView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .beginFromCurrentState )  {
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha = 1
                self.blur.alpha = 1
            }completion: { (true) in
                self.controller.view.isUserInteractionEnabled = true
            }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = controller.view.bounds
    }

        // Do any additional setup after loading the view.
    
    typealias CompletionHandler = (_ success: Bool) -> Void
    
    var alertAction: ((Bool) -> Void)?
    
    func buttomAction(succes: Bool,completion:CompletionHandler)  {
      
        
        completion(succes)
    }
   
//    func method(arg: Bool, completion: (Bool) -> ()) {
//        print("First line of code executed")
//        // do stuff here to determine what you want to "send back".
//        // we are just sending the Boolean value that was sent in "back"
//        completion(arg)
//    }
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        buttomAction(succes: true, completion: alertAction!)
        
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        closeAlert()
        buttomAction(succes: false, completion: alertAction!)
        
        //self.view.reservedAnimateView2(animatedView: blur)
        //self.view.reservedAnimateView2(animatedView: containerView)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
