//
//  ChartsCollectionView.swift
//  
//
//  Created by Артур on 4.02.21.
//

import UIKit


class ChartsCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
  
    static var layout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        ChartsCollectionView.layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ChartsCollectionView.layout.itemSize = CGSize(width: frame.width, height: frame.height)
        ChartsCollectionView.layout.scrollDirection = .horizontal
        ChartsCollectionView.layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: ChartsCollectionView.layout)
        
        
        
        self.delegate = self
        self.dataSource = self
        self.isPagingEnabled = true
        self.register(ChartsCollectionViewCell.self, forCellWithReuseIdentifier: ChartsCollectionViewCell.identifier)
        self.backgroundColor = .black
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Is selected indexPath in collectionView = \(indexPath.row) class ChartsCollectionView")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsCollectionViewCell.identifier, for: indexPath)
        
        return cell
    }
}
