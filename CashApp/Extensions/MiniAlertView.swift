//
//  MiniAlertView.swift
//  
//
//  Created by Артур on 9.07.21.
//

import UIKit

enum MiniAlertStyle {
    case success
    case warning
    case error
}
class MiniAlertView: UIView {

    @IBOutlet var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
        messageLabel.text = "Some text"
        self.accessibilityIdentifier = "Alert-View"
    }

    func showAlert(){
        super.addSubview(self)
        
        
        self.frame = CGRect(x: super.bounds.width, y: 97, width: super.bounds.width - (Layout.side * 2), height: 98)
        //miniAlert.messageLabel.text = message
        UIView.animate(withDuration: 0.45, delay: 0,usingSpringWithDamping: 0.7,initialSpringVelocity: 0.9,options: .curveEaseInOut) {
            self.frame.origin.x = Layout.side
        }completion: { (true) in
            UIView.animate(withDuration: 0.25,delay: 2.0) {
                    self.frame.origin.x = self.bounds.width
                }completion: { _ in
                    self.removeFromSuperview()
            }
        
        }
        
    }
    
    func visualSettings() {
        messageLabel.font = .systemFont(ofSize: 22, weight: .regular)
        messageLabel.textColor = ThemeManager.currentTheme().titleTextColor
        messageLabel.numberOfLines = 2
        self.layer.cornerRadius = 22
        self.layer.cornerCurve = .continuous
        self.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        self.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        //self.alpha = 0.98
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visualSettings()
    }
    func setMessage(message: String) {
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("coder")
        self.accessibilityIdentifier = "Alert-View" //Идентификатор для распознования представления исключающий повтор
    }
}
extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
