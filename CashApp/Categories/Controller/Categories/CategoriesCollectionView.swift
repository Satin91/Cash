//
//  CategoriesCollectionView.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


//MARK: Collectiom view delegate dataSource
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = changeValue ? Array(expenceObjects).count: Array(incomeObjects).count
        switch changeValue {
        case true:
            count = Array(expenceObjects).count > 0 ? Array(expenceObjects).count + 1: 1
        case false:
            count = Array(incomeObjects).count > 0 ? Array(incomeObjects).count + 1: 1
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell2: CreateOperationCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateOperationCell.identifier, for: indexPath) as! CreateOperationCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperationCell", for: indexPath) as! OperationCell
        
        // let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CreateOperationCell.identifier, for: indexPath) as! CreateOperationCell
        switch changeValue {
        case true:
            if indexPath.row == expenceObjects.count {
                return cell2
            }else{
                let object = expenceObjects[indexPath.row]
                cell.set(object: object)
            }
        case false :
            if indexPath.row == incomeObjects.count {
                return cell2
            }else{
                let object = incomeObjects[indexPath.row]
                cell.set(object: object)
                return cell
            }
        }
        return cell
    }
    
    private func createNewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
             
            let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(5/5), heightDimension: .fractionalHeight(5/5)))
            if self.view.bounds.width > 400 {
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
            }
            
            let subGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(2/5)), subitem: trailingItem, count: 3)
           // subGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(25)
            subGroup.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
            
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: subGroup, count: 4)
            trailingGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26)
            
            let section = NSCollectionLayoutSection(group: trailingGroup)
            
            section.orthogonalScrollingBehavior = .paging
            return section
        }
        
        return layout
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch changeValue {
        case true:
            if indexPath.row != expenceObjects.count {
                let object =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                goToQuickPayVC(PayObject: object)
            }else{
                goToAddVC(object: nil, isEditing: false)
            }
        case false:
            if indexPath.row != incomeObjects.count {
                let object =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                goToQuickPayVC(PayObject: object)
            }else{
                goToAddVC(object: nil, isEditing: false)
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let press = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: press) {
            
           //отмена нажатия если нажата кнопка "добавить новую категорию"
            switch changeValue {
            case true:
                guard indexPath.row != expenceObjects.count else {return}
            case false:
                guard indexPath.row != incomeObjects.count else {return}
            }
            if gesture.state == .began {
                let cell = collectionView.cellForItem(at: indexPath)
                pressedIndexPath = indexPath
                goToPopUpTableView(delegateController: self, payObject: [indexPath], sourseView: cell!)
            }
        }
    }
    
    func setupCollectionView() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createNewLayout()
        collectionView.addGestureRecognizer(gesture)
        collectionView.register(OperationCell.nib(), forCellWithReuseIdentifier: "OperationCell")
        collectionView.register(CreateOperationCell.nib(), forCellWithReuseIdentifier: CreateOperationCell.identifier)
        
    }
    
}
