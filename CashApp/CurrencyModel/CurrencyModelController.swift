//
//  CurrencyModelController.swift
//  
//
//  Created by Артур on 5.05.21.
//

import Foundation


var currencyObjecs = [CurrencyObject]()



class CurrencyModelController {
    var currencyObject = CurrencyObject(ISO: "", exchangeRate: 0)
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
                    currencyObjecs.append(object)
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
        for i in  currencyObjecs{
            //guard let identifier = i.identifier else {continue}
            if validISOList.contains(i.ISO){
                object = i
            }
        }
        return object
    }

    public func convertString(_ value : Double?, inputCurrency : String?, outputCurrency : String?) -> Double? {
        guard inputCurrency != nil, outputCurrency != nil else {return nil}
        guard let inputRate = fetchedCurrencyObject?.rates[inputCurrency!] else { return nil }
        guard let outputRate =  fetchedCurrencyObject?.rates[outputCurrency!] else { return nil }
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
    public func convert(_ value : Any?, inputCurrency : String?, outputCurrency : String?) -> Double? {
        guard inputCurrency != nil, outputCurrency != nil, value != nil else {return nil}
        let value = returnDoubleValue(value)
        guard let inputRate = fetchedCurrencyObject?.rates[inputCurrency!] else { return nil }
        guard let outputRate =  fetchedCurrencyObject?.rates[outputCurrency!] else { return nil }
        let multiplier = outputRate/inputRate
        return value! * multiplier
    }
    public func makeCurrency(ISO : String?, rate : Double?) -> CurrencyObject? {
        guard let ISO = ISO else { return nil }
        guard let rate = rate else {return nil}
        guard validISOList.contains(ISO) else { return nil}
        let object = CurrencyObject(ISO: ISO, exchangeRate: rate)
        return object
    }
}
