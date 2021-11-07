//
//  CreateScheduleCell.swift
//  CashApp
//
//  Created by Артур on 27.06.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import Themer


class CreateScheduleCell: UITableViewCell {
    
    @IBOutlet var createScheduleLabel: TitleLabel!
    @IBOutlet var dashView: UIView!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: "CreateScheduleCell", bundle: nil)
        return nib
    }
    var lockView: LockView!
    var border =  CAShapeLayer()
    
    func lock(_ isLock: Bool) {
        lockView.lock(!isLock)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dashView.backgroundColor = .clear
        lockView = LockView(frame: self.bounds)
        
        createScheduleLabel.text = NSLocalizedString("add_schedule_button", comment: "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func visualSettings() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.dashView.backgroundColor = .clear
        self.dashView.layer.cornerRadius = 25
        self.dashView.layer.cornerCurve = .continuous
        self.createScheduleLabel.font = .systemFont(ofSize: 26, weight: .regular)
        
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        Themer.shared.register(target: self, action: CreateScheduleCell.theme(_:))
        dashView.center = self.contentView.center
        createScheduleLabel.center = self.contentView.center
        visualSettings()
        lockView.addLock(to: self, lockSize: .plan)
    }
}

extension CreateScheduleCell {
    private func theme(_ theme: MyTheme) {
        self.contentView.backgroundColor = theme.settings.backgroundColor
        self.border.strokeColor = theme.settings.borderColor.cgColor
        dashView.drawDash(radius: 25,layer: self.border)
    }
}
