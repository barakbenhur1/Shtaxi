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
    @discardableResult func withHeaders(_ values: Haeder...) -> URLRequest {
        var request = self
        values.forEach { request.setValue($0.value, forHTTPHeaderField: $0.headerField) }
        return request
    }
    
    @discardableResult func withHttpMethod(_ method: String) -> URLRequest {
        var request = self
        request.httpMethod = method
        return request
    }
    
    @discardableResult func withHttpBody(_ body: Data) -> URLRequest {
        var request = self
        request.httpBody = body
        return request
    }
}
