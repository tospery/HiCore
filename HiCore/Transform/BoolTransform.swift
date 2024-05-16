//
//  BoolTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper
import SwifterSwift

/// Transforms value of type Any to Bool. Tries to typecast if possible.
public class BoolTransform: TransformType {
    public typealias Object = Bool
    public typealias JSON = Bool
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let value = value else { return nil }
        if let bool = value as? Bool {
            return bool
        } else if let int = value as? Int {
            return int.bool
        } else if let double = value as? Double {
            return double.bool
        } else if let string = value as? String {
            return string.safeBool
        } else if let number = value as? NSNumber {
            return number.boolValue
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

// ******************************* MARK: - Singleton
public extension BoolTransform {
    static let shared = BoolTransform()
}
