//
//  CreateScheduleCell.swift
//  CashApp
//
//  Created by Артур on 27.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit

class CreateScheduleCell: UITableViewCell {
    
    @IBOutlet var createScheduleLabel: UILabel!
    @IBOutlet var dashView: UIView!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: "CreateScheduleCell", bundle: nil)
        return nib
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .clear
        self.dashView.backgroundColor = .clear
        createScheduleLabel.text = "Добавить"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func visualSettings() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.dashView.backgroundColor = .clear
        
        self.createScheduleLabel.font = .systemFont(ofSize: 26, weight: .regular)
        self.createScheduleLabel.textColor = ThemeManager.currentTheme().contrastColor1
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        drawDash(view: self.dashView)
        visualSettings()
    }
    func drawDash(view: UIView) {
        //Нужно чтобы слой не повторялся
        view.layer.sublayers?.removeAll()
        let border = CAShapeLayer()
        border.removeFromSuperlayer()
        border.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 25).cgPath
        //border.path = UIBezierPath(roundedRect:dashView.bounds, cornerRadius:10.0).cgPath
        border.frame = dashView.bounds
        border.fillColor = nil
        border.strokeColor = ThemeManager.currentTheme().subtitleTextColor.cgColor
        border.lineWidth = 2 // doubled since half will be clipped
        border.lineDashPattern = [15.0,4]
        view.layer.addSublayer(border)
    }
    
}
