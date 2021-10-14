//
//  CancelButton.swift
//  
//
//  Created by Артур on 12.09.21.
//

import UIKit

enum CancelButtonType: String {
    
    case cancel = "Cancel"
    case create = "Create"
    case close = "X"
    
    var description: String {
        return self.rawValue
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
        
        ownerViewController.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        // addToView()
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
        self.backgroundColor = colors.titleTextColor.withAlphaComponent(0.15)
        self.setTitle(buttonTitle.description, for: .normal)
        self.setTitleColor(colors.titleTextColor, for: .normal)
        self.layer.cornerRadius = frame.height / 2
        self.layer.setSmallShadow(color: colors.shadowColor)
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
        self.setTitle("TITLE", for: .normal)
        
        //setup()
    }
    
    @objc func buttonAction (_sender: UIButton, action:@escaping ()->()) {
        
    }
    
}
