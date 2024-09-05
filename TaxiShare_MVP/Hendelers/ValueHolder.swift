//
//  ValueHolder.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 01/09/2024.
//

import Foundation

class Holder<Value: Any>: ObservableObject {
    @Published var value: Value?
}
