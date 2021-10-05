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

extension IconsCollectionView {
    func theme(_ theme: MyTheme) {
        view.backgroundColor = theme.settings.backgroundColor
    //    boundsForCollection.backgroundColor =
    //    boundsForCollection.layer.setMiddleShadow(color: theme.settings.shadowColor)
        self.view.backgroundColor = theme.settings.backgroundColor
    }
}
class IconsCollectionView: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var sendImageDelegate: SendIconToParentViewController!
    var selectedImageName = "card"
    
    let cancelButton = UIButton()
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        Themer.shared.register(target: self, action: IconsCollectionView.theme(_:))
    }

    func setupCollectionView(){
        collectionView = UICollectionView(frame: self.view.bounds,collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        
        self.view.addSubview(collectionView)
        self.view.layer.cornerRadius = 0.5
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        let nib = UINib(nibName: "AddCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "addCell")
    }
    let imagesForCollection = ["transport.0","transport.1","transport.2","transport.3","transport.4","transport.5","transport.6","food.0","food.1","food.2","food.3","food.4","food.5","food.6","gift.0","entertainment.0","entertainment.1","entertainment.2","casino.0","casino.1","insurance.0","animal.0","furniture.0","furniture.1","furniture.2","furniture.3","celebration.0","celebration.1","celebration.2","music.0","music.1","music.2","electronics.0","electronics.1","electronics.2","electronics.3","electronics.4","electronics.5","electronics.6","electronics.7","bills.0","bills.1","bills.2","bills.3","bills.4","housing.0","housing.1","child.0","repair.0","repair.1","work.0","encouragement.0","encouragement.1","clothes.0","clothes.1","clothes.2","clothes.3","clothes.4","beauty.0","beauty.1","beauty.2","sport.0","sport.1","services.0","knowledge.0","knowledge.1"]
    
    let transportIcons = ["airplane","car.fill","fuelpump.fill","bolt.car.fill","bus.fill","tram.fill","ferry.fill","train.side.front.car","bicycle","scooter"]
    let healthIcons = ["heart.text.square.fill","bandage.fill","cross.case.fill","pills.fill","cross.vial.fill","cross.fill","waveform.path.ecg","tooth.c","dentistChair.c"]
    let electronicsIcons = ["camera.fill","smartPhone.c","videoCamera.c","desktopComputerPC.c", "display","repairComputer.c", "laptopcomputer","cloudStorage.c","headphones","hifispeaker.fill","headphones.c","radio.fill","play.tv.fill","watch.c"]
    let buildingIcons = ["building.2.fill","building.columns.fill"]
    let gameIcons = ["gamecontroller.fill","logo.playstation","logo.xbox","playingСards.c"]
    let clothers = ["sneakers.c","tshirt.fill"]
    let knowledgeIcons = ["book.fill","books.vertical.fill","text.book.closed.fill","graduationcap.fill","ampoule.c"]
    let billsIcons = ["newspaper.fill","network","drop.fill","bolt.fill","phone.and.waveform.fill"]
    let musicIcons = ["music.note","music.mic","pianokeys","guitars.fill"]
    let repairIcons = ["wrench.fill","hammer.fill","roller.c","drill.c"]
    let entertaimentIcons = ["theatermasks.fill","film.fill","bearPint.c"]
    let restIcons = ["bed.double.fill","leaf.fill","wood.c"]
    let animalIcons = ["pawprint.fill"]
    let shoppingIcons = ["cart.fill","creditcard.fill","productBasket.c","groceryPackage.c"]
    let beautyIcons = ["scissors"]
    let foodIcons = ["cup.and.saucer.fill","knifeAndFork.c","foodСover.c"]
    let giftIcons = ["gift.fill"]
    let insuranceIcons = ["checkmark.shield.fill"]
    let flowersIcons = ["homeFlower.c","roseFlower.c"]
    let loveIcons = ["dateAppointment.c"]
    let childrenIcons = ["babyCarriage.c"]
    let encouragementIcons = ["encouragement.c","discount.c"]   // Поощрения и скидки
    let workIcons = ["office.c","working.c","workTime.c"]
    
    
    lazy var totalIconsArray = [transportIcons,healthIcons,electronicsIcons,buildingIcons,gameIcons,knowledgeIcons,billsIcons,musicIcons,repairIcons,entertaimentIcons,restIcons,animalIcons,shoppingIcons,beautyIcons,foodIcons,giftIcons,insuranceIcons]
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
        
        let itemsPerRow: CGFloat = 4
        let paddingWidth = 10 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 17
    }

    //                UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = enumeratedIconsNames(totalIconsArray)[indexPath.row]
        selectedImageName = image
        sendImageDelegate.sendIconName(name: selectedImageName)
        dismiss(animated: true, completion: nil)
    }
    
    //                 UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enumeratedIconsNames(totalIconsArray).count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell
        //let images = imagesForCollection[indexPath.item]
        //let image = imageToData(imageName: images)// Перевод в Data нужен лишь для того чтобы потом можно было с легкостью сохранить изображение в базу данных, открыть в ячейке можно и не png файл
        
        let images = enumeratedIconsNames(totalIconsArray)[indexPath.row]
        let image = UIImage().myImageList(systemName: images)
        
        cell.set(image: image!)
        
        //cell.imageView.image = image
        //cell.imageView.setImageColor(color: ThemeManager2.currentTheme().titleTextColor)
        
        
        return cell
    }
}
extension UIImage {
    func myImageList(systemName: String) -> UIImage? {
        guard let image = UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(weight: .thin )) else {
            let image = UIImage(named: systemName)
            return image}
        return image
    }
}
