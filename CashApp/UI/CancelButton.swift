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
    
    var description: String {
        return self.rawValue
        }
    }


class CancelButton: UIButton {
    private let colors = AppColors()
    private  var buttonTitle: CancelButtonType!
    private var ownerViewController: UIViewController!
    
  
    init(frame: CGRect, title: CancelButtonType, owner: UIViewController) {
        super.init(frame: frame)
        colors.loadColors()
        self.buttonTitle = title
        self.ownerViewController = owner
       
        ownerViewController.navigationController?.navigationBar.isUserInteractionEnabled = false
        
       // addToView()
    }
    
     func addToParentView(view: UIView){
        let width: CGFloat = 80
        let height: CGFloat = 34
        let x = ownerViewController.view.bounds.width - 26 - width
        let y :CGFloat = 26
        self.frame = CGRect(x: x, y: y, width: width, height: height)
         setup()
        view.insertSubview(self, at: 10)
    }
   private func setup() {
        self.backgroundColor = colors.titleTextColor
        self.setTitle(buttonTitle.description, for: .normal)
        self.setTitleColor(colors.backgroundcolor, for: .normal)
        self.layer.cornerRadius = frame.height / 2
    self.layer.setMiddleShadow(color: colors.shadowColor)
    self.addTarget(self, action: #selector(CancelButton.closeVC(_:)), for: .touchUpInside)
    }

    
    func addToScrollView(view: UIView) {
        let width: CGFloat = 80
        let height: CGFloat = 34
        let x = ownerViewController.view.bounds.width - 26 - width
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
        self.backgroundColor = colors.titleTextColor
        //setup()
    }
    
    @objc func buttonAction (_sender: UIButton, action:@escaping ()->()) {
        
    }
    
}
