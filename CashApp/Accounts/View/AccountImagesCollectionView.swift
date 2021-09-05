//
//  AccountImagesCollectionView.swift
//  CashApp
//
//  Created by Артур on 5.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol ActionsWithAccount {
    func actionsWithAccount()
}
class AccountImagesCollectionView: UIView {
    
    var collectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupCollectionView()
    }
    let accountsImages = ["account1","account2","account3","account4"]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var account: MonetaryAccount?
    var delegate: ActionsWithAccount!
    
    func setupCollectionView() {
        
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.addSubview(collectionView)
        createConstraints()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AccountImageCell.self, forCellWithReuseIdentifier: "AccountImageCell")
        collectionView.showsVerticalScrollIndicator = false
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minimumSpacing: CGFloat = 20
        let width: CGFloat = (collectionView.bounds.width / 2 ) - minimumSpacing / 2
        let height: CGFloat = (collectionView.bounds.height / 2 ) - minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: height )
        layout.minimumLineSpacing = minimumSpacing
        layout.minimumInteritemSpacing = minimumSpacing / 2
    }
    func createConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension AccountImagesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accountsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountImageCell", for: indexPath) as! AccountImageCell
        cell.set(image: UIImage(named: accountsImages[indexPath.row])!)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let account = self.account else {return}
        try! realm.write({
            account.imageForAccount = accountsImages[indexPath.row]
        })
        delegate.actionsWithAccount()
    }
    
    
    
}
