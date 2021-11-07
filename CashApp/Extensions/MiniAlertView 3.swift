//
//  MiniAlertView.swift
//  
//
//  Created by Артур on 9.07.21.
//

import UIKit
import Themer


enum MiniAlertStyle {
    
        case success
        case warning
        case error
    //prompt
        case date
        case textFields
        case moreThan
        case image
    }
    
   


class MiniAlertView: UIView {

    @IBOutlet var alertImage: UIImageView!
    @IBOutlet var messageLabel: TitleLabel!
    let colors = AppColors()
    weak var controller: UIViewController!
    let setVisual = SetAlertViewVisual()
     override init(frame: CGRect) {
        super.init(frame: frame)
     //   visualSettings()
         
        self.accessibilityIdentifier = "Alert-View"
    }


    
    
    func showMiniAlert(message: String, alertStyle: MiniAlertStyle) {
        guard checkControllerSubviews() else {return}
        alertImage.image = setVisual.setImage(alertStyle: alertStyle)
        backgroundColor = setVisual.setBackgroundColor(alertStyle: alertStyle)
        visualSettings()
        self.frame = CGRect(x: controller.view.bounds.width, y: 97, width: controller.view.bounds.width , height: 60)
        controller.view.addSubview(self)
        self.messageLabel.text = message
        UIView.animate(withDuration: 0.45, delay: 0,usingSpringWithDamping: 0.7,initialSpringVelocity: 0.9,options: .curveEaseInOut) {
            self.frame.origin.x = 0 // Layout.side
        }completion: { (true) in
            UIView.animate(withDuration: 0.25,delay: 2.0) {
                self.frame.origin.x = self.controller.view.bounds.width
                }completion: { _ in
                    self.removeFromSuperview()
            }
        }
    }
    
    func checkControllerSubviews() -> Bool{
        for i in controller.view.subviews {
            if i.accessibilityIdentifier == "Alert-View" {
                return false
            }
        }
        return true
    }
    
    //MARK: Scheduler
    func showAlertForScheduler(textFields: [UITextField],imageName: String, date: Date?) -> Bool {
        var message = ""
        for i in textFields {
            if i.text == "" {
                message = NSLocalizedString("enter_all_fields", comment: "")
                self.showMiniAlert(message: message, alertStyle: .textFields)
                return false
            }
        }
        guard date != nil else {
            message = NSLocalizedString("indicate_a_date", comment: "")
            self.showMiniAlert(message: message, alertStyle: .date)
            return false
        }
        guard imageName != "emptyImage" else {
            message = NSLocalizedString("select_an_image", comment: "")
            self.showMiniAlert(message: message, alertStyle: .image)
            return false
        }
        return false
    }
    //MARK: Category
    func showAlertForCategories(textField: UITextField,imageName: String)-> Bool {
        
        guard textField.text != "" else {
            self.showMiniAlert(message: NSLocalizedString("enter_category_name", comment: ""), alertStyle: .textFields)
           return false
        }
        guard imageName != "emptyImage" else {
            self.showMiniAlert(message: NSLocalizedString("select_an_image", comment: "") , alertStyle: .image)
            return false
        }
        return true
    }
    
    
    
    func visualSettings() {
        colors.loadColors()
        alertImage.setImageColor(color: colors.backgroundcolor)
        messageLabel.font = .systemFont(ofSize: 22, weight: .regular)
        messageLabel.textColor = colors.backgroundcolor
        messageLabel.numberOfLines = 1
        messageLabel.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = 0
        self.layer.setSmallShadow(color: colors.shadowColor)
        self.alpha = 0.95
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visualSettings()
    }
    func setMessage(message: String) {
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.accessibilityIdentifier = "Alert-View" //Идентификатор для распознования представления исключающий повтор
    }
}
extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
extension MiniAlertView {
    func theme(_ theme: MyTheme ) {
        
    }
}
