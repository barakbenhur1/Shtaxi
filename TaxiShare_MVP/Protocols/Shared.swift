//
//  Shared.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 10/09/2024.
//

import Foundation

class Shared: NSObject, ObservableObject {
    private typealias SharedChase = [String: NSObject]
    
    static private var _chase = SharedChase()
    static private var _barrier: [String] = []
    static private var currentInitilized: String? { return _barrier.last }
    static var shared: Self { return value("\(self)") }
    
    internal override init() {
        Shared.vaildate("\(Self.self)".asClassName())
    }
    
    private static func vaildate(_ className: String) {
        guard currentInitilized == className else { fatalError("class \"\(className)\" must use shared property") }
    }
    
    static private func value<T: NSObject>(_ key: String) -> T {
        _barrier.append(key)
        if _chase[key] == nil { _chase[key] = T() }
        _ = _barrier.popLast()
        return _chase[key] as! T
    }
}
