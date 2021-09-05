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
    }
}
extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
