//
//  CurrencyRequestModel.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

struct CurrencyRequestModel: Encodable {
    let amount: Int
    let to_currency: String
    let from_currency: String
}
