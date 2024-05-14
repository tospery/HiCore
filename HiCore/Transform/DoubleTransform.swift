//
//  DoubleTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper

/// Transforms value of type Any to Double. Tries to typecast if possible.
public class DoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = Double
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if value == nil {
            return nil
        } else if let double = value as? Double {
            return double
        } else if let int = value as? Int {
            return Double(int)
        } else if let bool = value as? Bool {
            return (bool ? 1.0 : 0.0)
        } else if let string = value as? String {
            return Double.safeFrom(string)
        } else if let number = value as? NSNumber {
            return number.doubleValue
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

public extension DoubleTransform {
    static let shared = DoubleTransform()
}
