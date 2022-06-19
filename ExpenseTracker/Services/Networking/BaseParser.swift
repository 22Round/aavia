//
//  BaseParser.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

typealias PolicyCompletion<T: Decodable> = (T?, Error?)-> Void

class BaseParser {
    
    func parseJSON<T: Decodable>(json: Data, type: T.Type, completion: PolicyCompletion<T>) {
        
        let decoder = JSONDecoder()
        do {
            let mod: T = try decoder.decode(T.self, from: json)
            completion(mod, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}
