//
//  ChartsCollectionView.swift
//  
//
//  Created by Артур on 4.02.21.
//

import UIKit
import AAInfographics

class LineChartCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
   
    
 
    var model = AAChartModel()
    var chartView = AAChartView()
    var element: [AASeriesElement] = []
    let accountDestination = ContainerViewController.destinationName
    
    static var layout = UICollectionViewFlowLayout()
    //let VC = ContainerViewController()
    var accountName: String = ""
    let data: [Double] = [25,52,25,25,52,25,36,47,25,14]
    let data2: [Double] = [25,57,76,553,4,466,74,745,47,36]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        element = [(AASeriesElement().name(accountDestination!).data(data)),(AASeriesElement().name(accountDestination!).data(data2))]
        accountName = ContainerViewController.destinationName!
        print(accountName)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "LineChartViewCell")
        //self.collectionView.register(LineChartCollectionViewCell.self, forCellWithReuseIdentifier: "LineChartViewCell")
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .clear
        self.view.backgroundColor = .clear
        
        chartView.backgroundColor = .red
        
        
        
        LineChartCollectionViewController.layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        LineChartCollectionViewController.layout.itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        LineChartCollectionViewController.layout.scrollDirection = .horizontal
        LineChartCollectionViewController.layout.minimumLineSpacing = 0
        
     
       
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Is selected indexPath in collectionView = \(indexPath.row) class ChartsCollectionView")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return element.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LineChartViewCell", for: indexPath)
        chartView = AAChartView(frame: self.view.bounds)
        //let el = element[indexPath.row]
        
        
        model.series([element[indexPath.row]])
        chartView.aa_drawChartWithChartModel(model)
        cell.addSubview(chartView)
        cell.backgroundColor = .clear
        
        return cell
    }

}

