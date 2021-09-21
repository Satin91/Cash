//
//  SendOrReceiveModel.swift
//  CashApp
//
//  Created by Артур on 18.09.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation

enum TransferType: String {
    case send
    case receive
    
    var image: String {
        switch self {
        case .receive:
            return "transfer.receive"
        case .send:
            return "transfer.send"
        }
    }
}

struct TransferModel {
    var account: MonetaryAccount
    var transferType: TransferType
}
