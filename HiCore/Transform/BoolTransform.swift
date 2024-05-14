//
//  BoolTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper

/// Transforms value of type Any to Bool. Tries to typecast if possible.
public class BoolTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = Bool
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let bool = value as? Bool {
            return bool
        } else if let int = value as? Int {
            return (int != 0)
        } else if let double = value as? Double {
            return (double != 0)
        } else if let string = value as? String {
            return Bool.safeFrom(string)
        } else if let number = value as? NSNumber {
            return number.boolValue
        } else {
            print("Can not cast value of type \(type(of: value!)) to type \(Object.self): \ndata = \(["value": value])")
            return nil
        }
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

// ******************************* MARK: - Singleton

public extension BoolTransform {
    static let shared = BoolTransform()
}


//public class BoolTransform: TransformType {
//
//    public typealias Object = Bool
//    public typealias JSON = Any
//    
//    public init() {}
//    
//    public func transformFromJSON(_ value: Any?) -> Bool? {
//        if let bool = value as? Bool {
//            return bool
//        } else if let int = value as? Int {
//            return int.bool
//        } else if let string = value as? String {
//            return string.bool
//        } else {
//            return nil
//        }
//    }
//
//    public func transformToJSON(_ value: Bool?) -> Any? {
//        return value
//    }
//    
//}
