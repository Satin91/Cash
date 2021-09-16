//
//  AccountImagesCollectionView.swift
//  CashApp
//
//  Created by Артур on 5.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
//protocol ActionsWithAccount {
//    func actionsWithAccount()
//}
class AccountImagesCollectionView: UIView {
    
    var collectionView: UICollectionView!
    var closure: ((String) -> ())?
    func sendImage() {
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupCollectionView()
    }
    let accountsImages = ["account1", "account2", "account3", "account4"]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var account: MonetaryAccount? {
        willSet {
            getImageIndex()
            collectionView.reloadData()
        }
    }
  //  var delegate: ActionsWithAccount!
    var indexPathForScale: IndexPath = IndexPath(row: 2, section: 0)
    
    func setupCollectionView() {
        
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.addSubview(collectionView)
        createConstraints()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AccountImageCell.self, forCellWithReuseIdentifier: "AccountImageCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
        
    }
    deinit {
        
        print("deinit")
    }
    func getImageIndex(){
        guard account != nil else {return}
        for (index, value) in accountsImages.enumerated() {
            if account!.imageForAccount == value {
                indexPathForScale = IndexPath(row: index, section: 0)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let minimumSpacing: CGFloat = self.bounds.height / 10
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
        
        //setupCollectionView()
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
        if indexPathForScale == indexPath {
            cell.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        //let cell = collectionView.cellForItem(at: indexPath)
        sendImage(imageName: accountsImages[indexPath.row], closure: closure!)
        
        indexPathForScale = indexPath
        collectionView.reloadData()
        
    }
    func sendImage(imageName:String, closure: (String)-> Void) {
        closure(imageName)
    }
    func setBorder(cell: UICollectionViewCell) {
        let view = UIView(frame: CGRect(x: cell.bounds.origin.x - 10, y:  cell.bounds.origin.y - 10, width: cell.bounds.width + 20, height: cell.bounds.height + 20))
        
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        
        self.addSubview(view)
    }
    
}
