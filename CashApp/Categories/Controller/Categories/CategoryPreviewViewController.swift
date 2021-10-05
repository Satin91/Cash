//
//  CategoryPreviewViewController.swift
//  CashApp
//
//  Created by Артур on 3.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CategoryPreviewViewController: UIViewController {
    var imageView = UIImageView()
    var label = UILabel()
    let colors = AppColors()
    var containerViewForImage = UIView()
    func fillTheDate(imageName: String, labelName: String) {
        createControls()
        imageView.image = UIImage().myImageList(systemName: imageName)
        imageView.setImageColor(color: colors.titleTextColor)
        imageView.layer.setSmallShadow(color: colors.shadowColor)
        label.text = labelName
       
    }
    func createLabel() {
        let font = preffContentSize.height / 6.8
        print(font / 6.8)
        label.font = .systemFont(ofSize: font, weight: .medium)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = colors.titleTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        view.addSubview(label)
        let inset: CGFloat = 8
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: containerViewForImage.topAnchor)
        ])
    }
    
    func createContainer() {
        containerViewForImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerViewForImage)
        containerViewForImage.backgroundColor = .clear
        containerViewForImage.layer.cornerRadius = 0
        containerViewForImage.layer.cornerCurve = .continuous
        NSLayoutConstraint.activate([
            containerViewForImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerViewForImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerViewForImage.topAnchor.constraint(equalTo: view.topAnchor, constant: preffContentSize.height / 3.5),
            containerViewForImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    func createImage() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerViewForImage.addSubview(imageView)
        let inset: CGFloat = 8
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: containerViewForImage.leftAnchor, constant: inset),
            imageView.rightAnchor.constraint(equalTo: containerViewForImage.rightAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: containerViewForImage.topAnchor,constant: inset),
            imageView.bottomAnchor.constraint(equalTo: containerViewForImage.bottomAnchor, constant: -inset),
        ])
    }
    var preffContentSize: CGSize!
    func createControls() {
        
        createContainer()
        createLabel()
        createImage()
        
    }
    
       override func viewDidLoad() {
       super.viewDidLoad()
           colors.loadColors()
           let width = view.bounds.width / 3
           let contentsize = CGSize(width: width, height: width * 1.2)
           preferredContentSize = contentsize
           preffContentSize = contentsize
           
           
           createControls()
           
           self.view.backgroundColor =  colors.secondaryBackgroundColor
           self.view.clipsToBounds = false
           
       // The preview will size to the preferredContentSize, which can be useful
       // for displaying a preview with the dimension of an image, for example.
       // Unlike peek and pop, it doesn't seem to automatically scale down for you.

           
   }
    deinit{
        print("deinit")
    }
}
