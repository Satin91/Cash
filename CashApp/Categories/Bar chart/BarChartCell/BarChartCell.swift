//
//  BarChartCell.swift
//  CashApp
//
//  Created by Артур on 13.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class BarChartCell: UITableViewCell {
    let colors = AppColors()
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var progresslineContainer: UIView!
    @IBOutlet var totalSumLabel: TitleLabel!
    @IBOutlet var persentLabel: SubTitleLabel!
    
    var progressLine: UIView!
    func visualSettings() {
        contentView.layer.cornerRadius = 12
        contentView.layer.setSmallShadow(color: colors.shadowColor)
        contentView.backgroundColor = colors.secondaryBackgroundColor
        progresslineContainer.backgroundColor = colors.borderColor.withAlphaComponent(0.3)
        progresslineContainer.layer.cornerRadius = progresslineContainer.bounds.height / 2
        totalSumLabel.font = .systemFont(ofSize: 14, weight: .medium)
        totalSumLabel.textColor = colors.subtitleTextColor
        categoryImage.setImageColor(color: colors.titleTextColor)
        progressLine.backgroundColor = colors.titleTextColor
        self.backgroundColor = .clear
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colors.loadColors()
        
        
    }
    func set(object: BarChartModel){
        categoryImage.image = UIImage(named: object.imageName)
        totalSumLabel.text = object.totalSum.currencyFormatter(ISO: object.ISO)
     //   setProgressLine(persent: object.persent)
        persentLabel.text = String(Int(object.persent)) + "%"
        visualSettings()
    }
    func setProgressLine(persent: Double) {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = CGFloat(progresslineContainer.bounds.width * CGFloat(persent / 100) )
        let height = progresslineContainer.bounds.height
        progressLine = UIView (frame: CGRect(x: x, y: y, width: width, height: height) )
        progressLine.layer.cornerRadius = height / 2
        progresslineContainer.addSubview(progressLine)
        progressLine.backgroundColor = .black
        
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visualSettings()
        self.contentView.frame = self.bounds.inset(by: UIEdgeInsets (top: 10, left: 0, bottom: 10, right: 0))
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
