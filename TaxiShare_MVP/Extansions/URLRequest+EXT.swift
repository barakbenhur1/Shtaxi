//
//  URLRequest+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 05/09/2024.
//

import Foundation

struct Haeder {
    let value: String
    let headerField: String
}

extension URLRequest {
    @discardableResult mutating func withHeaders(_ values: Haeder...) -> URLRequest {
        values.forEach { setValue($0.value, forHTTPHeaderField: $0.headerField) }
        return self
    }
}
