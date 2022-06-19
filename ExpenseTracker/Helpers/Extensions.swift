//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftUI

extension Double {
    
    func formattedCurrencyText(currencySymbol: String = "$") -> String {
        return Utils.numberFormatter(currencySymbol: currencySymbol).string(from: NSNumber(value: self)) ?? "0"
    }
}

extension Data {
    var toString: String? {
        return String(data: self, encoding: .utf8)
    }
}

extension Color {
    public static func customColor(red: Double, green: Double, blue: Double, opacity: Double = 1) -> Color {
        
        Color(red: red/225, green: green/225, blue: blue/225, opacity: opacity)
    }
}
