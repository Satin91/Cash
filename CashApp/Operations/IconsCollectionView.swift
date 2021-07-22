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
    let imagesForCollection = ["alcohol", "appliances", "bank", "bankCard", "books", "bowling", "cancel", "car", "carRepair", "carwash", "casino", "cellphone", "charity", "cigarettes", "cinema", "cleaning", "clothes", "construction", "cosmetics", "delivery", "dentist", "drugs", "education", "electricity", "error", "fitness", "flights", "flowers", "food", "fuel", "furniture", "games", "gas", "gifts", "glasses", "goverment", "hello", "hotel", "housing", "identification", "insurancy", "internet", "kids", "laundry", "lock", "luxuries", "magazine", "media", "medicine", "musicalInstruments", "other", "parking", "pets", "pool", "publicTransport", "purchases", "refill", "request", "send", "shoeRepair", "sport", "stadium", "stationery", "taxes", "taxi", "telephone", "tollRoad", "tourism", "toys", "trafficFine", "train", "tv", "unlock", "waterRransport", "withdraw"]
    
    
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
        let selectedImage = UIImage(named: image)
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
        let image = imageToData(imageName: images)// Перевод в Data нужен лишь для того чтобы потом можно было с легкостью сохранить изображение в базу данных, открыть в ячейке можно и не png файл
        
       
        cell.imageView.image = UIImage(data: image)
        cell.imageView.setImageColor(color: whiteThemeMainText)
        
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
