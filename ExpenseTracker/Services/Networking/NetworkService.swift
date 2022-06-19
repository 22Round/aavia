//
//  NetworkService.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

class NetworkService {
    
    enum HttpMethod {
        case post, get
        var description: String {
            switch self {
            case .post: return "POST"
            default: return "GET"
            }
        }
    }
    
    enum Route {
        case currency
        var description: String {
            switch self {
            default: return "https://elementsofdesign.api.stdlib.com/aavia-currency-converter@dev/"
            }
        }
    }
    
    func fetchData<T: Encodable>(route: Route, method: HttpMethod, modelType: T.Type, model: T, completion:@escaping (Data?, URLResponse?, Error?)-> Void) {
        guard let url = URL(string: route.description) else { return }
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = method.description
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(model)
            request.httpBody = jsonData
            
        } catch let error {
            print(error.localizedDescription)
            completion(nil, nil, error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if error != nil {
                completion(nil, res, error)
                return
            }
            completion(data, res, nil)
            
        }.resume()
    }
}
