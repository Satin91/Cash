//
//  CollectionViewSetup.swift
//  CashApp
//
//  Created by Артур on 6.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

extension SubscriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x + (self.view.bounds.width / 2)
        switch offset {
        case 0...self.view.bounds.width:
            self.pageControl.currentPage = 0
        case self.view.bounds.width...(self.view.bounds.width * 2) :
            self.pageControl.currentPage = 1
        case (self.view.bounds.width * 2)...(self.view.bounds.width * 3):
            self.pageControl.currentPage = 2
        default :
            break
        }
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
     //   collectionView.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: "SubscriptionCell")
        let layout = UICollectionViewFlowLayout()
        let sideDistance: CGFloat = 22
        let width = collectionView.bounds.width - (sideDistance * 2)
        let height = collectionView.bounds.height
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideDistance, bottom: 0, right: sideDistance)
        layout.minimumLineSpacing = sideDistance * 2
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = layout
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subscriptioDescription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCollectionViewCell
        let object = self.subscriptioDescription[indexPath.row]
        cell.set(description: object)
        return cell
    }
    
    
    
    
}
