//
//  CategoriesCollectionView.swift
//  CashApp
//
//  Created by Артур on 14.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Network


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
        let createCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateOperationCell.identifier, for: indexPath) as! CreateOperationCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperationCell", for: indexPath) as! OperationCell
        
         
        switch changeValue {
        case true:
            if indexPath.row == expenceObjects.count {
                createCell.layoutSubviews() // требуется для того чтобы даш выглядел как надо
                //createCell.lock(true)
                indexPath.row >= subscriptionManager.allowedNumberOfCells(objectsCountFor: .categories)
                ? createCell.lock(true)
                : createCell.lock(false)
                
                return createCell
            }else{
                let object = expenceObjects[indexPath.row]
                cell.set(object: object)
                indexPath.row >= subscriptionManager.allowedNumberOfCells(objectsCountFor: .categories)
                ? cell.lock(true)
                : cell.lock(false)
 
            }
        case false :
            if indexPath.row == incomeObjects.count {
                createCell.layoutSubviews() // требуется для того чтобы даш выглядел как надо
                indexPath.row >= subscriptionManager.allowedNumberOfCells(objectsCountFor: .categories)
                ? createCell.lock(true)
                : createCell.lock(false)
                return createCell
            }else{
                let object = incomeObjects[indexPath.row]
                cell.set(object: object)
                indexPath.row >= subscriptionManager.allowedNumberOfCells(objectsCountFor: .categories)
                ? cell.lock(true)
                : cell.lock(false)
                return cell
            }
        }
        return cell
    }
    
    private func compositionLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
             
            var trailingItem: NSCollectionLayoutItem!
            print(self.view.bounds.width)
            if self.view.bounds.width > 380 {
                trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(5/5), heightDimension: .fractionalHeight(4/5)))
            } else {
                trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
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
        //View subscription view controller if needed
        if indexPath.row >= subscriptionManager.allowedNumberOfCells(objectsCountFor: .categories) {
            self.showSubscriptionViewController()
        }
        switch changeValue {
        case true:
            if indexPath.row != expenceObjects.count {
                let object =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                goToQuickPayVC(reloadDelegate: nil, PayObject: object)
            }else{
                
                goToAddVC(object: nil, isEditing: false)
            }
        case false:
            if indexPath.row != incomeObjects.count {
                let object =  changeValue ? Array(expenceObjects)[indexPath.row] : Array(incomeObjects)[indexPath.row]
                goToQuickPayVC(reloadDelegate: nil, PayObject: object)
            }else{
                goToAddVC(object: nil, isEditing: false)
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch changeValue {
        case true :
            guard indexPath.row != expenceObjects.count else { return nil }
        case false:
            guard indexPath.row != incomeObjects.count else { return nil }
        }
        // create cell identifier in configuration
        let index = indexPath.row
        let identifier = "\(index)" as NSString
        //let object = expenceObjects[indexPath.row]
        let categoryObject = changeValue ? expenceObjects[index] : incomeObjects[index]
        let provider = CategoryPreviewViewController().self
        provider.fillTheDate(imageName: categoryObject.image, labelName: categoryObject.name)
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
           
            return provider
        }) { suggestedActions in
            let editAction =
                       UIAction(title: NSLocalizedString("pop_edit_name_label", comment: ""),
                                image: UIImage(systemName: "square.and.pencil")) { action in
                           
                                       DispatchQueue.main.async {
                                           self.goToAddVC(object: categoryObject, isEditing: true)
                                       }
                       }
                   let deleteAction =
                       UIAction(title: NSLocalizedString("pop_delete_name_label", comment: ""),
                                image: UIImage(systemName: "trash"),
                                attributes: .destructive ) { action in
                                       try! realm.write({
                                           realm.delete(categoryObject)
                                       })
                                       collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                                       collectionView.reloadData()
                       }
            
            let menu = UIMenu(title: "",options: .displayInline , children: [editAction, deleteAction])
            return menu
        }
    }
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
            guard
                //receive identifier from configuration
                let identifier = configuration.identifier as? String,
                let index = Int(identifier),
                let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? OperationCell
                  else {
                    return nil
                }
        
     //   return UITargetedPreview(view: cell.roundedRect, parameters: UIPreviewParameters. , target: <#T##UIPreviewTarget#>)
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.shadowPath = .none
        parameters.visiblePath = .none
        
        return UITargetedPreview(view: cell.roundedRect ,parameters: parameters)
        }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            //receive identifier from configuration
            let identifier = configuration.identifier as? String,
            let index = Int(identifier),
            let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? OperationCell
              else {
                return nil
            }
    let parameters = UIPreviewParameters()
        parameters.shadowPath = .none
    parameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.roundedRect,parameters: parameters)
    }

    func setupCollectionView() {
      //  let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = self.compositionLayout()
        //collectionView.addGestureRecognizer(gesture)
        collectionView.register(OperationCell.nib(), forCellWithReuseIdentifier: "OperationCell")
        collectionView.register(CreateOperationCell.nib(), forCellWithReuseIdentifier: CreateOperationCell.identifier)
        collectionView.isScrollEnabled = false // Изза compositional layout, отменить вертикальный скроллинг можно только так
    }
    
}
