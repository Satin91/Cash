//
//  AddAccountViewController.swift
//  CashApp
//
//  Created by Артур on 21.01.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    @IBAction func okButton(_ sender: UIBarButtonItem) {
        saveElement()
        
    }
    var imageView = UIImageView()
    let accountImages = ["account1","account2","account3","account4"]
    var textForUpperLabel = ""
    var textForMiddleLabel = ""
    var textForBottomLabel = ""
    var indexForImage: IndexPath = [0,0]
    //Border neo bouds for textFields
    @IBOutlet var nameBorderButton: BorderButtonView!
    @IBOutlet var targetBorderButton: BorderButtonView!
    @IBOutlet var balanceBorderButton: BorderButtonView!
    
    
    @IBOutlet var collectionView: UICollectionView! // Делегат и источник назначены в сториборде
    
    //Actions buttons
    @IBAction func createAccountAction(_ sender: Any) {
   
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
    @IBOutlet var selectDateView: NeomorphicView!
    //Actions
    @IBAction func selectDateButton(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViwSettings()
        setupNavigationController(Navigation: navigationController!)
        setColorTheme()
        visualSettings()
        setTextForViewElements()
        checkType()
        
        
    }
    func saveElement(){
        newAccount.imageForAccount = UIImage(named: accountImages[indexForImage.row])?.pngData()
        if !nameTextField.text!.isEmpty{
            newAccount.name = nameTextField.text!
        }
        if !targetTextField.text!.isEmpty {
            newAccount.targetSum = Double(targetTextField.text!)!
        }
        if !balanceTextField.text!.isEmpty {
            newAccount.balance = Double(balanceTextField.text!)!
        }
        DBManager.addAccountObject(object: [newAccount])
        
    }
    func setTextForViewElements() {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        targetTextField.attributedPlaceholder = NSAttributedString(string: "Target", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        balanceTextField.attributedPlaceholder = NSAttributedString(string: "Balance", attributes: [NSAttributedString.Key.foregroundColor: whiteThemeTranslucentText ])
        selectDateButtonOutlet.setTitle("Select Date", for: .normal)
        navigationItem.rightBarButtonItem?.title = "Create"
        navigationItem.leftBarButtonItem?.title = "Cancel"
        //Labels
        upperTextLabel.text = textForUpperLabel
        middleTextLabel.text = textForMiddleLabel
        bottomTextLabel.text = textForBottomLabel
    }
    
    
    func collectionViwSettings() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true // Позволяет считать ячейки для того чтобы центрировать при прокрутке, хотя тут вообще он сам по себе центрирует без лишних методов)) очень удобно!
    }
    
    func languageSettings() {
        
    }
    
    func visualSettings(){
        nameTextField.borderStyle = .none
        targetTextField.borderStyle = .none
        balanceTextField.borderStyle = .none
        
        selectDateButtonOutlet.setTitleColor(whiteThemeMainText, for: .normal)
        selectDateButtonOutlet.titleLabel?.setLabelSmallShadow(label: selectDateButtonOutlet.titleLabel!)
        for i in [nameTextField,targetTextField,balanceTextField]{
            i!.textColor = whiteThemeMainText
        }
    }
    func checkType () {
        switch newAccount.stringAccountType {
        case .card :
            targetTextField.isHidden = true
            targetBorderButton.isHidden = true
        case .cash :
            targetBorderButton.isHidden = true
            targetTextField.isHidden = true
        case .box  :
            targetTextField.isHidden = false
        }
    }
    let shadow = CALayer()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
    }
    func setColorTheme() {
        self.view.backgroundColor = whiteThemeBackground
        self.collectionView.backgroundColor = .none
        upperTextLabel.textColor = whiteThemeMainText
        middleTextLabel.textColor = whiteThemeRed
        bottomTextLabel.textColor = whiteThemeMainText
        
        
        upperTextLabel.setLabelMiddleShadow(label: upperTextLabel)
        middleTextLabel.setLabelMiddleShadow(label: middleTextLabel)
        bottomTextLabel.setLabelMiddleShadow(label: bottomTextLabel)
        
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
        //collectionView.layer.masksToBounds = false
        //cell.accountImageView.setImageShadow(image: cell.accountImageView)
        //        shadow.frame = cell.accountImageView.bounds
        //        shadow.cornerRadius = 20
        //        shadow.backgroundColor = UIColor.white.cgColor
        //        shadow.shadowColor = #colorLiteral(red: 0.5019607843, green: 0.5960784314, blue: 0.6666666667, alpha: 1)
        //        shadow.shadowOffset = CGSize(width: 2, height: 2) // Размер
        //        shadow.shadowOpacity = 1
        //        shadow.shadowRadius = 4 //Радиус
        
        // self.view.layer.insertSublayer(shadow, at: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
}


