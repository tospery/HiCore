//
//  IntTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper

/// Transforms value of type Any to Int. Tries to typecast if possible.
public class IntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = Int
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let int = value as? Int {
            return int
        } else if let double = value as? Double {
            return Int.safeFrom(double)
        } else if let bool = value as? Bool {
            return (bool ? 1 : 0)
        } else if let string = value as? String {
            return Int.safeFrom(string)
        } else if let number = value as? NSNumber {
            return number.intValue
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

public extension IntTransform {
    static let shared = IntTransform()
}


//public class IntTransform: TransformType {
//
//    public typealias Object = Int
//    public typealias JSON = Any
//    
//    public init() {}
//    
//    public func transformFromJSON(_ value: Any?) -> Int? {
//        if let bool = value as? Bool {
//            return bool.int
//        } else if let int = value as? Int {
//            return int
//        } else if let string = value as? String {
//            return string.int
//        } else {
//            return nil
//        }
//    }
//
//    public func transformToJSON(_ value: Int?) -> Any? {
//        return value
//    }
//    
//}
