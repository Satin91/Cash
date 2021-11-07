//
//  ImageCollectionView.swift
//  CashApp
//
//  Created by Артур on 19.04.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer
protocol SendIconToParentViewController{
    func sendIconName(name: String)
}


class IconsViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var sendImageDelegate: SendIconToParentViewController!
    var selectedImageName = "card"
   // let cancelButton = UIButton()
    
    let images = IconsModelController().getAllIcons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        Themer.shared.register(target: self, action: IconsViewController.theme(_:))
    }
    deinit{
        print("Deinit icons view")
    }
    func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        initConstraints(view: self.collectionView, to: self.view)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "AddCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "addCell")
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
    }
   
    struct CollectionSections {
        var collectionName: String
        var collectionIcons: [String]
    }
    let collectionSections: [CollectionSections] = []

    private func enumeratedIconsNames(_ array: [[String]]) -> [String] {
        var names: [String] = []
        for values in array {
            for name in values {
                names.append(name)
            }
        }
        return names
    }
    
    
 

    
    //                  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideInset: CGFloat = 26
        let itemsPerRow: CGFloat = 6
        let paddingWidth = 10 * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingWidth - (sideInset * 2)
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 20, left: 26, bottom: 20, right: 26)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 17
    }
    
    //                UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
      //  selectedImageName = image
        let selectedImageName = images[indexPath.section].icons[indexPath.row]
        sendImageDelegate.sendIconName(name: selectedImageName)
        dismiss(animated: true, completion: nil)
    }
    
    //                 UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let object = images[section]
        
        return object.icons.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell
    
        let section = images[indexPath.section]
        let imageName = section.icons[indexPath.row]
        let image = UIImage().myImageList(systemName: imageName)
        cell.set(image: image!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        header.configure()
        let objectName = images[indexPath.section].name
        let name = NSLocalizedString(objectName, comment: "")
        
        header.label.text = name
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 46)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images.count
    }

}

extension IconsViewController {
    func theme(_ theme: MyTheme) {
        view.backgroundColor = theme.settings.backgroundColor
        self.view.backgroundColor = theme.settings.backgroundColor
    }
}

