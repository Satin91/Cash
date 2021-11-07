//
//  SubscriptionCellModelController.swift
//  CashApp
//
//  Created by Артур on 6.11.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit


class SubscriptionCellModelController {
//        func setupLabels() {
//            unlimitLabel.text            = NSLocalizedString("unlimit_header_label", comment: "")
//            unlimitDescription.text      = NSLocalizedString("unlimit_descriptions", comment: "")
//            notificationLabel.text       = NSLocalizedString("notifications_header_label", comment: "")
//            notificationDescription.text = NSLocalizedString("notifications_descriptions", comment: "")
//            familyLabel.text             = NSLocalizedString("family_header_label", comment: "")
//            familyDescription.text       = NSLocalizedString("family_descriptions", comment: "")
//            let buttonText = SubscribtionStatus.trialWasActive == true
//            ? NSLocalizedString("subscription_button_subscribe", comment: "")
//            : NSLocalizedString("subscription_button_try_free", comment: "")
//            subscriptionButton.setTitle(buttonText, for: .normal)
//        }
//    subscribe.unlimit
//    subscribe.notification
//    person.3
    func getImage(name: String) -> UIImage {
        let image = UIImage().getNavigationImage(systemName: name, pointSize: 12, weight: .regular)
        return image
    }
    func loacalize(string: String) -> String {
        let str = NSLocalizedString(string, comment: "")
        return str
    }
    
    lazy var subscriptionModel: [SubscriptionCellModel] = [
        SubscriptionCellModel(image: getImage(name: "subscribe.unlimit"), title: loacalize(string: "unlimit_header_label"), description: loacalize(string: "unlimit_descriptions")),
        SubscriptionCellModel(image:getImage(name: "subscribe.notification") , title: loacalize(string:"notifications_header_label"), description: loacalize(string:"notifications_descriptions")),
        SubscriptionCellModel(image:getImage(name: "person.3") , title: loacalize(string:"family_header_label"), description:loacalize(string: "family_descriptions"))]
    
}
