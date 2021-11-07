//
//  SeparatorView.swift
//  CashApp
//
//  Created by Артур on 11.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer

extension SeparatorView {
    func theme(_ theme: MyTheme) {
        self.separatorView.backgroundColor = theme.settings.separatorColor
    }
}
class SeparatorView {
    
    var cell: UITableViewCell!
    var separatorView: UIView!
    init(cell: UITableViewCell) {
        self.cell = cell
    }
    func createLineView() -> UIView {
        let height: CGFloat = 2
        let separatorView = UIView(frame: CGRect(x: 0, y: cell.bounds.height - height, width: cell.bounds.width, height: height))
        self.separatorView = separatorView
        Themer.shared.register(target: self, action: SeparatorView.theme(_:))
        return separatorView
    }
    func createLineViewWithConstraints() -> UIView{
        //let separatorView = UIView(frame: cell.bounds)
        self .separatorView = UIView(frame: cell.bounds)
        cell.addSubview(self.separatorView)
        let height: CGFloat = 2
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: height).isActive = true
        //self.separatorView = separatorView
        Themer.shared.register(target: self, action: SeparatorView.theme(_:))
        return self.separatorView
    }
}
