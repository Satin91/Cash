//
//  CurrencyModelController.swift
//  
//
//  Created by Артур on 5.05.21.
//

import Foundation



class CurrencyModelController {
   // var currencyObject = CurrencyObject2(ISO: "", exchangeRate: 0)

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
        
        guard inputCurrency != nil, outputCurrency != nil, value != nil else {return nil}
        
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
    
//    func getCurrencyFromValidISOList(currency: String) -> CurrencyObject? {
//        var object: CurrencyObject?
//        for i in  currencyObjects{
//            //guard let identifier = i.identifier else {continue}
//            if validISOList.contains(i.ISO){
//                object = i
//            }
//        }
//        return object
//    }
    
    
}


