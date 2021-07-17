//
//  AlertViewController.swift
//  CashApp
//
//  Created by Артур on 8.07.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

enum AlertStyle {
    case delete
    case close
}

class AlertViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var alertImage: UIImageView!
    @IBOutlet var leftButtonOutlet: UIButton!
    @IBOutlet var rightButtonOutlet: UIButton!
    
    
    var alertStyle: AlertStyle?
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    func visualSettings() {
        //labels
        titleLabel.font = .systemFont(ofSize: 26, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = ThemeManager.currentTheme().titleTextColor
        titleLabel.textAlignment = .center
        
        
        messageLabel.font = .systemFont(ofSize: 17, weight: .light)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        messageLabel.textAlignment = .center
        //buttons
        
        leftButtonOutlet.backgroundColor = ThemeManager.currentTheme().contrastColor1
        leftButtonOutlet.layer.cornerRadius = leftButtonOutlet.bounds.height / 2
        leftButtonOutlet.setTitleColor(ThemeManager.currentTheme().backgroundColor, for: .normal)
        
        rightButtonOutlet.layer.borderWidth = 1
        rightButtonOutlet.layer.borderColor = ThemeManager.currentTheme().borderColor.cgColor
        rightButtonOutlet.layer.cornerRadius = leftButtonOutlet.bounds.height / 2
        
        self.containerView.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        self.containerView.layer.cornerRadius = 40
        self.containerView.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        self.view.backgroundColor = .clear
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: "AlertViewController", bundle: nil)
       
        }
    
    @IBOutlet var containerView: UIView!
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    func setAlertStyle(alertStyle: AlertStyle) {
        
        switch alertStyle {
        case .close:
            leftButtonOutlet.setTitle("Close", for: .normal)
            rightButtonOutlet.setTitle("Cancel", for: .normal)
        case .delete:
            leftButtonOutlet.setTitle("Delete", for: .normal)
            rightButtonOutlet.setTitle("Cancel", for: .normal)
        }
    }
    func closeAlert(blur: UIVisualEffectView) {
        self.removeFromParent()
        self.view.reservedAnimateView(animatedView: self.view, viewController: parent)
        self.view.reservedAnimateView2(animatedView: blur)
        blur.removeFromSuperview()
        parent?.tabBarController?.tabBar.showTabBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        visualSettings()
        blur.frame = self.view.bounds
        blur.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.view.insertSubview(blur, at: 0)
        
        
        
        // Do any additional setup after loading the view.
    }
    typealias CompletionHandler = (_ success: Bool) -> Void
    
    var alertAction: (Bool) -> Void = {_ in
    
    }
    
    func buttomAction(succes: Bool,completion:CompletionHandler)  {
      
        
        completion(succes)
    }
   
    func method(arg: Bool, completion: (Bool) -> ()) {
        print("First line of code executed")
        // do stuff here to determine what you want to "send back".
        // we are just sending the Boolean value that was sent in "back"
        completion(arg)
    }
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        buttomAction(succes: true, completion: alertAction)
        
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        buttomAction(succes: false, completion: alertAction)
        
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
