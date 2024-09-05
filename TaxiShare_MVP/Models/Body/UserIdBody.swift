//
//  UserIdBody.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/09/2024.
//

import Foundation

struct UserIdBody: DictionaryRepresentable {
    let id: String
    
    func toDict<T: DictionaryRepresentable>(appned value: T) -> [String: Any] {
        var dict = dictionary()
        return dict.merge(dict: value.dictionary())
    }
}
