//
//  CurrencyModelController.swift
//  
//
//  Created by Артур on 5.05.21.
//

import Foundation

class CurrencyModelController {
    var currencyObject = CurrencyObject2(ISO: "", exchangeRate: 0)
    var fetchedCurrencyObject: Rates?

    public func getCurrenciesFromJSON(){
        let urlString = "https://pastebin.com/raw/7XZ5v19y"
        guard let url = URL(string: urlString) else {return}
        var results: Rates?
        do {
            let jsonData = try Data(contentsOf: url )
            results = try JSONDecoder().decode(Rates.self, from: jsonData)
            if let results = results {
                fetchedCurrencyObject = results
               // var someAr = [bb]()
                for i in fetchedCurrencyObject!.rates {
                    let a = makeCurrency(ISO: i.key, rate: i.value)
                    guard let object = a else {continue}
                    let newRealmObject = CurrencyObject(ISO: object.ISO, exchangeRate: object.exchangeRate)
                    guard currencyObjects.count == validISOList.count else{
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
            }else {
                print("failed to parse")
            }
            return
        }
        catch {
            print("failed to parse")
        }

    }

    public func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }

    public func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }

    public func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }


    func getCurrencyFromValidISOList(currency: String) -> CurrencyObject? {
        var object: CurrencyObject?
        for i in  currencyObjects{
            //guard let identifier = i.identifier else {continue}
            if validISOList.contains(i.ISO){
                object = i
            }
        }
        return object
    }
    
    func getCurrencyFromRealm(ISO: String) -> Double? {
        guard currencyObjects.contains(where: { CurrencyObject in CurrencyObject.ISO == ISO })else{ return nil }
        var exchangeRate: Double?
        for i in currencyObjects {
            if i.ISO == ISO{
                exchangeRate = i.exchangeRate
            }
        }
        return exchangeRate
    }

    public func convert(_ value : Double?, inputCurrency : String?, outputCurrency : String?) -> Double? {
        guard inputCurrency != nil, outputCurrency != nil else {return nil}
       
        guard currencyObjects.contains(where: { ISO in ISO.ISO == inputCurrency!})else {return nil}
        let inputRate = getCurrencyFromRealm(ISO: inputCurrency!) ?? 0
        let outputRate = getCurrencyFromRealm(ISO: outputCurrency!) ?? 0
        let multiplier = outputRate/inputRate
        return value! * multiplier
    }
    private func returnDoubleValue(_ value: Any?) -> Double?{
        guard value != nil else {return nil}
        if value is String {
            let value = value as! String
            guard let result = Double(value.filter("0123456789.".contains)) else {return nil}
            return result
        }else if value is Double{
            let value = value as! Double
            return value
        }
        return 0
    }
    public func convert2(_ value : Any?, inputCurrency : String?, outputCurrency : String?) -> Double? {
        guard inputCurrency != nil, outputCurrency != nil, value != nil else {return nil}
        
        let value = returnDoubleValue(value)
        guard let inputRate = fetchedCurrencyObject?.rates[inputCurrency!] else { return nil }
        guard let outputRate =  fetchedCurrencyObject?.rates[outputCurrency!] else { return nil }
        let multiplier = outputRate/inputRate
        return value! * multiplier
    }
    public func makeCurrency(ISO : String?, rate : Double?) -> CurrencyObject2? {
        guard let ISO = ISO else { return nil }
        guard let rate = rate else {return nil}
        guard validISOList.contains(ISO) else { return nil}
        let object = CurrencyObject2(ISO: ISO, exchangeRate: rate)
        return object
    }
}
