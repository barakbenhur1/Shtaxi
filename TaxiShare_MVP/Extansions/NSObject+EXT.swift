//
//  NSObject+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 10/09/2024.
//

import Foundation

extension NSObject {
    // MARK: Type checking
    
//    /// Returns true if a value is an object.
//    func isObject <T> (value: T) -> Bool {
//        return Mirror(reflecting: value).
//    }
//    
    
    // MARK: Type casting
    
    /// Ensures the given value is an AnyObject.
    func toObject <T> (value: T!) -> _Object<T>! {
        return value == nil ? nil : _Object<T>(value)
    }
    
    /// Ensures the given object is a specific value type.
    ///
    /// Casts to the expected value type.
    ///
    /// Typically, use this with an AnyObject returned from `toObject(_:)`.
    ///
    func fromObject <T> (object: AnyObject!) -> T! {
        return object == nil ? nil : (object as? _Object<T>)?.value
    }
    
    ///// Ensures the given value is an NSObject.
    func toNSObject <T> (value: T!) -> NSObject! {
        return value == nil ? nil : _NSObject(_Object<T>(value))
    }
    //
    ///// Ensures the given NSObject is a specific value type.
    /////
    ///// Casts to the expected value type.
    /////
    ///// Typically, use this with an AnyObject returned from `toNSObject(_:)`.
    /////
    func fromNSObject <T> (object: AnyObject!) -> T! {
        return object == nil ? nil : fromObject(object: (object as? _NSObject)?.object) ?? _cast(value: object)
    }
    
    /// Casts a value to an inferred type, safely or unsafely.
    ///
    /// Passing `nil` always returns `nil`.
    ///
    /// Pass `true` for "unsafe" when you want to use `unsafeBitCast`.
    ///
    func cast <T,U> (value: T!, _ unsafe: Bool = false) -> U! {
        return value == nil ? nil : _cast(value: value, unsafe)
    }
    
    
    // MARK: Stand-in classes
    
    /// An AnyObject disguised as an NSObject
    class _NSObject : NSObject {
        var object: AnyObject
        init (_ object: AnyObject) { self.object = object }
    }
    
    /// An Any disguised as an AnyObject
    class _Object <T> {
        var value: T
        init (_ value: T) { self.value = value }
    }
    
    // MARK: Private
    
    private func _cast <T,U> (value: T, _ unsafe: Bool = false) -> U! {
        return unsafe ? unsafeBitCast(value, to: U.self) : value as? U
    }
    
    private func _fromObject <T> (object: AnyObject) -> T! {
        return (object as? _Object<T>)?.value ?? _cast(value: object)
    }
}
