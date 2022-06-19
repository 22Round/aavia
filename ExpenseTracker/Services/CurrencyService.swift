//
//  CurrencyService.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    
    func fetch<T: Decodable>(type: T.Type, completion: @escaping PolicyCompletion<T>)
}

class CurrencyService: BaseParser { }

extension CurrencyService: ServiceProtocol {
    func fetch<T: Decodable>(type: T.Type, completion: @escaping PolicyCompletion<T>) {
        let network: NetworkService = .init()
        let requestModel: CurrencyRequestModel = .init(amount: 1, to_currency: "EUR", from_currency: "USD")
        network.fetchData(route: .currency, method: .post, modelType: CurrencyRequestModel.self, model: requestModel) { data, res, error in
            guard let data = data else { return }
            self.parseJSON(json: data, type: T.self, completion: completion)
        }
    }
}
