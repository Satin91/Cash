//
//  EnlargeSecondTableViewCell.swift
//  CashApp
//
//  Created by Артур on 2.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    
    var delegate: SendEnlargeIndex!
    var object = Int()
    
    var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    var sumLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
    
    var sendButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        return button
    }()
    
    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var object2 = Int()
    override func prepareForReuse() {
        super.prepareForReuse()
        lineView.isHidden = false
    }
    
    
    func set(object: AccountsHistory, isLast: Bool) {
        nameLabel.text = object.name
        sumLabel.text = String(object.sum.currencyFR)
        self.image.image = UIImage(named: object.image!)
        if isLast == true {
            lineView.isHidden = true
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        
        
        contentView.backgroundColor = .clear
        sendButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        createConstraints()
    }
    
    @objc func pressed() {
        print("pressed \(object2)")
    }
    
    func createConstraints() {
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(sendButton)
        self.contentView.addSubview(sumLabel)
        self.contentView.addSubview(image)
        
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        image.heightAnchor.constraint(equalToConstant: 38).isActive = true
        image.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        sumLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sumLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        
        sendButton.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let superCell = superview?.next() as! UITableViewCell
            delegate.enlarge(object: superCell.indexPath!)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SendEnlargeIndex {
    func enlarge(object: IndexPath)
}
extension UIResponder {
    /**
     * Returns the next responder in the responder chain cast to the given type, or
     * if nil, recurses the chain until the next responder is nil or castable.
     */
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        
        let a = self.next
        let b = a?.next
        
        return next.flatMap({ b as? U ?? $0.next() })
    }
    func nextInOne<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return next.flatMap({ $0 as? U ?? $0.next() })
    }
}
extension UITableViewCell {
    var nextTableView: UITableView? {
        return self.nextInOne(of: UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return self.nextTableView?.indexPath(for: self)
        
    }
}
