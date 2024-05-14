//
//  StringTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper

/// Transforms value of type Any to String. Tries to typecast if possible.
public class StringTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let string = value as? String {
            return string
        } else if let int = value as? Int {
            return String(int)
        } else if let double = value as? Double {
            return String(double)
        } else if let bool = value as? Bool {
            return (bool ? "true" : "false")
        } else if let number = value as? NSNumber {
            return number.stringValue
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

public extension StringTransform {
    static let shared = StringTransform()
}


//public class StringTransform: TransformType {
//
//    public typealias Object = String
//    public typealias JSON = Any
//    
//    public init() {}
//    
//    public func transformFromJSON(_ value: Any?) -> String? {
//        if let bool = value as? Bool {
//            return bool.string
//        } else if let int = value as? Int {
//            return int.string
//        } else if let string = value as? String {
//            return string
//        } else {
//            return (self as? CustomStringConvertible)?.description
//        }
//    }
//
//    public func transformToJSON(_ value: String?) -> Any? {
//        return value
//    }
//    
//}
