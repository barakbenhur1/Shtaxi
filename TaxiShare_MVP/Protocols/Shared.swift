//
//  Shared.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 10/09/2024.
//

import Foundation

class Shared: NSObject, ObservableObject {
    private typealias SharedChase = [String: NSObject]
    
    private static var _chase = SharedChase()
    private static var _barrier: [String] = []
    private static var _currentInitilized: String? { return _barrier.last }
    static var shared: Self { return value(for: self) }
    
    private static var vaildate: (_ className: String) -> () {
        return { className in
            guard className == _currentInitilized else { fatalError("class \"\(className)\" must use shared property") }
        }
    }
    
    internal override init() {
        Self.vaildate("\(Self.self)".asClassName())
    }

    private static func value<T: NSObject>(for value: Shared.Type) -> T {
        let key = "\(value)"
        _barrier.append(key)
        if _chase[key] == nil { _chase[key] = T() }
        _ = _barrier.popLast()
        return _chase[key] as! T
    }
}
