//
//  File.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    let currencyType: CurrencyType
    var id: String { "\(category)\(sum)" }
}
