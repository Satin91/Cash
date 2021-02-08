//
//  lineChartTableViewCell.swift
//  CashApp
//
//  Created by Артур on 5.02.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class lineChartTableViewCell: UITableViewCell {

    @IBOutlet var lineChartCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        lineChartCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        lineChartCollectionView.backgroundColor = .clear
        lineChartCollectionView.delegate = self
        lineChartCollectionView.dataSource = self
        lineChartCollectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: "lineChartCollectionViewCell")
        lineChartCollectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(lineChartCollectionView)
        self.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension lineChartTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineChartCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    
    
}
