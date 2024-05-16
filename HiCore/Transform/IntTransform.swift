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
        guard let value = value else { return nil }
        if let int = value as? Int {
            return int
        } else if let double = value as? Double {
            return double.safeInt
        } else if let bool = value as? Bool {
            return bool.int
        } else if let string = value as? String {
            return string.safeInt
        } else if let number = value as? NSNumber {
            return number.intValue
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

// ******************************* MARK: - Singleton
public extension IntTransform {
    static let shared = IntTransform()
}
