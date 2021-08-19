//
//  ImageCollectionView.swift
//  CashApp
//
//  Created by Артур on 19.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
protocol SendIconToParentViewController{
    func sendIconName(name: String)
}
class IconsCollectionView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var sendImageDelegate: SendIconToParentViewController!
    var selectedImageName = "card"
    var boundsForCollection: UIView!
    let cancelButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        self.backgroundColor = .white
        setupBoundsForCollection()
        setupCollectionView()
        createButton()
    }
    
    func setupBoundsForCollection() {
        boundsForCollection = UIView(frame: CGRect(x: 0, y: self.bounds.height * 0.1, width: self.bounds.width * 0.8, height: self.bounds.height * 0.8))
        self.addSubview(boundsForCollection)
        boundsForCollection.backgroundColor = ThemeManager.currentTheme().secondaryBackgroundColor
        boundsForCollection.layer.setMiddleShadow(color: ThemeManager.currentTheme().shadowColor)
        boundsForCollection.center.x = self.center.x
        boundsForCollection.layer.cornerRadius = 18
        boundsForCollection.clipsToBounds = true
    }
    
    func createButton() {
        let buttonHeight: CGFloat = 60
        cancelButton.frame = CGRect(x: 0, y: self.bounds.height - buttonHeight, width: self.bounds.width, height: buttonHeight)
        self.addSubview(cancelButton)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        
    }

    
    @objc func buttonAction() {
        reservedAnimateView2(animatedView: self)
    }
    
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        self.layer.cornerRadius = 0.5
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        initConstraints(view: collectionView, to: boundsForCollection)
        let nib = UINib(nibName: "AddCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "addCell")
    }
    let imagesForCollection = ["transport.0","transport.1","transport.2","transport.3","transport.4","transport.5","transport.6","food.0","food.1","food.2","food.3","food.4","food.5","food.6","gift.0","entertainment.0","entertainment.1","entertainment.2","casino.0","casino.1","insurance.0","animal.0","furniture.0","furniture.1","furniture.2","furniture.3","celebration.0","celebration.1","celebration.2","music.0","music.1","music.2","electronics.0","electronics.1","electronics.2","electronics.3","electronics.4","electronics.5","electronics.6","electronics.7","bills.0","bills.1","bills.2","bills.3","bills.4","housing.0","housing.1","child.0","repair.0","repair.1","work.0","encouragement.0","encouragement.1","clothes.0","clothes.1","clothes.2","clothes.3","clothes.4","beauty.0","beauty.1","beauty.2","sport.0","sport.1","services.0","knowledge.0"]
    
    
    //                  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 4
        let paddingWidth = 10 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 17
    }
    
    //    @available(iOS 6.0, *)
    //    optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    
    //                UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imagesForCollection[indexPath.row]
        selectedImageName = image
        sendImageDelegate.sendIconName(name: selectedImageName)
        
        reservedAnimateView2(animatedView: self)
//        view.reservedAnimateView(animatedView: popUpView, viewController: nil)
//        view.reservedAnimateView(animatedView: blurView, viewController: nil)
        
        
    }
    //                 UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesForCollection.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell
        let images = imagesForCollection[indexPath.item]
        //let image = imageToData(imageName: images)// Перевод в Data нужен лишь для того чтобы потом можно было с легкостью сохранить изображение в базу данных, открыть в ячейке можно и не png файл
        let image = UIImage(named: images)
        
        
        cell.imageView.image = image
        cell.imageView.setImageColor(color: ThemeManager.currentTheme().titleTextColor)
        
        
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
