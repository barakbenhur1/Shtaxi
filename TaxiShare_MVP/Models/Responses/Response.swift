//
//  Response.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 31/08/2024.
//

import Foundation

struct Response<T: Codable>: Codable {
    let value: T
}
