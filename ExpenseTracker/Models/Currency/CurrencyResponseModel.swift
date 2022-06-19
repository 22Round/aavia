//
//  CurrencyResponseModel.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

struct CurrencyResponseModel: Decodable {
    let amount: Double
    let rate: Double
}
