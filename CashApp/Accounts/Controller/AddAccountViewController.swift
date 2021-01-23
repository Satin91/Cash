//
//  AddAccountViewController.swift
//  CashApp
//
//  Created by Артур on 21.01.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    var imageView = UIImageView()
    let accountImages = ["account1","account2","account3"]
    var textForUpperLabel = ""
    var textForMiddleLabel = ""
    var textForBottomLabel = ""
    var indexForImage: IndexPath = [0,0]
    @IBOutlet var collectionView: UICollectionView! // Делегат и источник назначены в сториборде
    @IBAction func doneAction(_ sender: Any) {
        saveElement()
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var newAccount = MonetaryAccount()
    //TextLabels
    @IBOutlet var upperTextLabel : UILabel!
    @IBOutlet var middleTextLabel : UILabel!
    @IBOutlet var bottomTextLabel : UILabel!
    //TextFields
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var targetTextField : UITextField!
    @IBOutlet var balanceTextField : UITextField!
    //Outlets
    @IBOutlet var selectDateButtonOutlet: UIButton!
    //Actions
    @IBAction func selectDateButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViwSettings()
        setupNavigationController(Navigation: navigationController!)
        setColorTheme()
        textForLabels()
        visualSettings()
        
    }
    func saveElement(){
        newAccount.imageForAccount = UIImage(named: accountImages[indexForImage.row])?.pngData()
        DBManager.addAccountObject(object: [newAccount])
        
    }
    
    func collectionViwSettings() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true // Позволяет считать ячейки для того чтобы центрировать при прокрутке, хотя тут вообще он сам по себе центрирует без лишних методов)) очень удобно!
    }
    
    func textForLabels(){
        upperTextLabel.text = textForUpperLabel
        middleTextLabel.text = textForMiddleLabel
        bottomTextLabel.text = textForBottomLabel
        
    }
    func languageSettings() {
        
    }
    
    func visualSettings(){
        nameTextField.borderStyle = .none
        targetTextField.borderStyle = .none
        balanceTextField.borderStyle = .none
    }
    
    func setColorTheme() {
        self.view.backgroundColor = whiteThemeBackground
        self.collectionView.backgroundColor = .none
        upperTextLabel.textColor = whiteThemeMainText
        middleTextLabel.textColor = whiteThemeRed
        bottomTextLabel.textColor = whiteThemeMainText
        
        
        setCustomShadow(label: upperTextLabel, color: whiteThemeShadowText.cgColor, radius: 3, opacity: 0.6, size: CGSize(width: 2, height: 2))
        setCustomShadow(label: middleTextLabel, color: whiteThemeShadowText.cgColor, radius: 3, opacity: 0.6, size: CGSize(width: 2, height: 2))
        setCustomShadow(label: bottomTextLabel, color: whiteThemeShadowText.cgColor, radius: 3, opacity: 0.6, size: CGSize(width: 2, height: 2))
        
    }
    
    
    
}
extension AddAccountViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    //                  UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: view.bounds.width , height: collectionView.bounds.height)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    //CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountImages.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect() // создали квадрат

         visibleRect.origin = collectionView.contentOffset // инициализировали квадрат
         visibleRect.size = collectionView.bounds.size // задали ему размеры как у колекции

         let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY) // установили точку в центре квадрата
         
         guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return } //проверка на присутствие ячейки в этой точке
         indexForImage = indexPath
         print(indexPath) // отладочная печать для индекса
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddCollectionViewCell
        let images = accountImages[indexPath.item]
        let image = imageToData(imageName: images) // Перевод в Data нужен лишь для того чтобы потом можно было с легкостью сохранить изображение в базу данных, открыть в ячейке можно и не png файл
        cell.accountImageView.image = UIImage(data: image)
        cell.accountImageView.layer.cornerRadius = 20
        cell.accountImageView.clipsToBounds = true

    
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }

}


