//
//  DeleteUnnecessary.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

func unique<S : Sequence, T : CurrencyObject>(source: S) -> [T] where S.Iterator.Element == T {
    var buffer = [T]()
    var added = Set<T>()

    for elem in source {
        if !added.contains(where: { object in
            object.ISO == elem.ISO
        }) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}

class DeleteUnnecessary {
    
    func deleteDublicates() {
        let unique     = unique(source: currencyObjects)
        if currencyObjects.count != unique.count {
            var curObj = enumeratedALL(object: currencyObjects)
            curObj     = unique
            curObj.removeAll()
            for (_,value) in currencyObjects.enumerated(){
                try! realm.write {
                    realm.delete(value)
                }
            }
        }
    }
    func deleteUnValid() {
        for x in currencyObjects {
            if !CurrencyList().validISOList.contains(x.ISO) {
                try! realm.write {
                    realm.delete(x)
                }
            }
        }
    }
}
