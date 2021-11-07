//
//  Images.swift
//  CashApp
//
//  Created by Артур on 19.10.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import UIKit
import PurchasesCoreSwift

class IconsModelController {
    struct SectionsModel{
        var name : String
        var icons: [String]
    }
    
    func getNames() -> [SectionsModel]{
        //var returnedArray = [String:[String]]()
        var returningArray = [SectionsModel]()
        let allIcons = IconsModel()
        let mirror = Mirror(reflecting: allIcons)
        for child in mirror.children {
            if child.value is [String] {
                // Следующее свойство класса
                let nextValue = child.value as! [String]
                returningArray.append(SectionsModel(name: child.label ?? "", icons: nextValue))
            }
        }
        return returningArray
    }
    var getAllIcons : [SectionsModel] {
        get {
            return getNames()
        }
    }
}

