//
//  Networking.swift
//  CashApp
//
//  Created by Артур on 3.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit



class CurrencyNetworking {
    
    enum FileType {
        case URL
        case defaultData
    }
    
    let deleteUnnecessary = DeleteUnnecessary()
    let url               = "https://pastebin.com/raw/7XZ5v19y"
    let storageUrl        = Bundle.main.url(forResource: "DefaultCurrencies", withExtension: "json")
    var fetchedCurrencyObject: Rates?
    let currencyList      = CurrencyList()
    
    struct Rates: Codable {
        let rates: [String:Double]
    }
    func loadCurrencies() {
        // Загрузить данные из
        if NetworkMonitor.shared.isConnected == false && currencyObjects.count == 0 {
            self.getCurrenciesFromJSON(from: .defaultData)
        }else{
            self.getCurrenciesFromJSON(from: .URL)
        }
    }
    private func getCurrenciesFromJSON(from :FileType ){
        let url = URL(string: self.url)
        let data = from == .URL ? url : self.storageUrl
        var results: Rates?
        do {
            let jsonData = try Data(contentsOf: data!)
            results = try JSONDecoder().decode(Rates.self, from: jsonData)
            if let results = results {
                fetchedCurrencyObject = results
                structTheFetchedData()
            }
            return
        }
        catch {
            print("failed to parse")
        }
    }
    
    fileprivate func structTheFetchedData() {
        //Удаляет если название не валидное
        deleteUnnecessary.deleteDublicates()
        deleteUnnecessary.deleteUnValid()
        
        for i in fetchedCurrencyObject!.rates {
            let a = makeCurrency(ISO: i.key, rate: i.value)
            guard let object = a else {continue}
            
            let newRealmObject = CurrencyObject(ISO: object.ISO, exchangeRate: object.exchangeRate)
            guard currencyObjects.count == currencyList.validISOList.count else{
                if currencyObjects.contains(where: { thisObject in
                    thisObject.ISO == object.ISO
                }){
                    for i in currencyObjects {
                        if i.ISO == newRealmObject.ISO {
                            try! realm.write {
                                i.exchangeRate = newRealmObject.exchangeRate
                                realm.add(i,update: .all)
                            }
                        }
                    }
                }else{
                    try! realm.write{
                        realm.add(newRealmObject)
                    }
                }
                continue}
            for i in currencyObjects {
                if i.ISO == newRealmObject.ISO {
                    try! realm.write {
                        i.exchangeRate = newRealmObject.exchangeRate
                        realm.add(i,update: .all)
                    }
                }
            }
        }
    }
    
    
    
    public func makeCurrency(ISO : String?, rate : Double?) -> CurrencySample? {
        guard let ISO = ISO else { return nil }
        guard let rate = rate else {return nil}
        guard currencyList.validISOList.contains(ISO) else { return nil}
        let object = CurrencySample(ISO: ISO, exchangeRate: rate)
        return object
    }
}
class CurrencySample {
    var ISO: String = ""
    var exchangeRate: Double = 0
    //var currencyOperations = CurrencyOperations()
    
    init(ISO: String,exchangeRate: Double) {
        self.ISO = ISO
        self.exchangeRate = exchangeRate
    }
}
