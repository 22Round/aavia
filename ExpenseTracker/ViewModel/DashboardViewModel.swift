//
//  DashboardViewModel.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

class DashboardViewModel: ObservableObject {
    let service: CurrencyService = .init()
    @Published var categoriesSum: [CategorySum]?
    @Published var totalExpenses: Double?
    @Published var currencyType: CurrencyType = .usd
    @Published var isLoading: Bool = false
    
    var currencyRate: Double = 1
    lazy var currencySign = currencyType == .usd ? "$" : "€"
    
    func updateCurrency() {
        isLoading = true
        service.fetch(type: CurrencyResponseModel.self) { [weak self] model, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            if let model = model {
                self?.currencyRate = model.rate
                self?.fetchTotalSums(rate: model.rate)
            }
        }
    }
    
    func fetchTotalSums(rate: Double = 1) {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: CoreDataStack.shared.viewContext) { [unowned self] (results) in
            guard !results.isEmpty else { return }
            currencySign = currencyType == .usd ? "$" : "€"
            let totalSum = results.map { $0.sum }.reduce(0, +) * rate
            totalExpenses = totalSum
            categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum * rate, category: result.category, currencyType: currencyType)
            })
        }
    }
}
