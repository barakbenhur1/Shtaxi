//
//  Shared.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 10/09/2024.
//

import Foundation

class Shared: NSObject, ObservableObject {
    private typealias SharedChase = [String: Shared]
    
    private static var chase = SharedChase()
    
    static var shared: Self { return getValue(key: "\(self)") }
    
    required internal override init() {}
    
    static private func getValue(key: String) -> Self {
        if chase[key] == nil { chase[key] = Self.init() }
        return chase[key] as! Self
    }
}
