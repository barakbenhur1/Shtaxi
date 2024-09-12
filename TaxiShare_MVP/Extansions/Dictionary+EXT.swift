//
//  Dictionary+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 31/08/2024.
//

import Foundation

extension Dictionary {
    func httpBody() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
    
    func requestFormatted() -> String {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
    
    @discardableResult mutating func merge(dict: [Key: Value]) -> Dictionary<Key, Value> {
        for (k, v) in dict { updateValue(v, forKey: k) }
        return self
    }
}

protocol DictionaryRepresentable {
    func dictionary() -> [String: Any]
}

extension DictionaryRepresentable {
    func dictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        
        var dict: [String: Any] = [:]
        
        for (_, child) in mirror.children.enumerated() {
            if let label = child.label {
                dict[label] = child.value
            }
        }
        
        return dict
    }
}
