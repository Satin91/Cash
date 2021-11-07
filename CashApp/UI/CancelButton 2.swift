//
//  CancelButton.swift
//  
//
//  Created by Артур on 12.09.21.
//

import UIKit

enum CancelButtonType: String {
    
    case cancel = "cancel_button"
    case create = "Create"
    case close = ""
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}


class CancelButton: UIButton {
    private let colors = AppColors()
    private  var buttonTitle: CancelButtonType!
    weak var ownerViewController: UIViewController!
    let y: CGFloat = 26
    
    init(frame: CGRect, title: CancelButtonType, owner: UIViewController) {
        super.init(frame: frame)
        colors.loadColors()
        self.buttonTitle = title
        self.ownerViewController = owner
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byWordWrapping
        ownerViewController.navigationController?.navigationBar.isUserInteractionEnabled = false
    }

    func addToNavBar(navBar: UIView) {
       // guard let navBar = navBarView else { return }
        
        let height: CGFloat = 34
        var width: CGFloat = 0
       
        switch buttonTitle {
        case .cancel:
            width = 80
           
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        case .create:
            width = 80
        case .close:
            self.setImage(UIImage().getNavigationImage(systemName: "xmark", pointSize: 26, weight: .medium), for: .normal)
            self.tintColor = colors.titleTextColor
            width = height
        case .none:
            break
        }
        let x: CGFloat = (navBar.bounds.width - 26) - width
        let y: CGFloat = (navBar.bounds.height - height) / 2
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        setup()
        navBar.addSubview(self)
    }
    func addToParentView(view: UIView){
        var width: CGFloat = 0
        let height: CGFloat = 34
        switch buttonTitle {
        case .cancel:
            width = 80
        case .create:
            width = 80
        case .close:
            self.setImage(UIImage().getNavigationImage(systemName: "xmark", pointSize: 26, weight: .medium), for: .normal)
            self.tintColor = colors.titleTextColor
            width = height
        case .none:
            break
        }
        let x = ownerViewController.view.bounds.width - 26 - width
        let y :CGFloat = self.y
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        setup()
        view.insertSubview(self, at: 10)
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.setTitle(buttonTitle.description, for: .normal)
        self.setTitleColor(colors.titleTextColor, for: .normal)
        self.layer.cornerRadius = frame.height / 6
        //self.layer.setSmallShadow(color: colors.shadowColor)
        self.addTarget(self, action: #selector(CancelButton.closeVC(_:)), for: .touchUpInside)
    }
    
    
    func addToScrollView(view: UIView) {
        let navBarHeight = UINavigationController().navigationBar.frame.height
        print(navBarHeight)
        let width: CGFloat = 80
        let height: CGFloat = 34
        let x = ownerViewController.view.bounds.width - 26 - width
    //    let y: CGFloat = (navBarHeight / 2) + (height / 2)
        let y :CGFloat = ownerViewController.view.frame.origin.y - height
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        setup()
        view.insertSubview(self, at: 10)
    }
    @objc private func closeVC(_ sender: UIButton) {
        ownerViewController.dismiss(animated: true, completion: nil)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        colors.loadColors()
    }
    
    @objc func buttonAction (_sender: UIButton, action:@escaping ()->()) {
        
    }
    
}
