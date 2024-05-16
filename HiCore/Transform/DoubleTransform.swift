//
//  DoubleTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper
import SwifterSwift

/// Transforms value of type Any to Double. Tries to typecast if possible.
public class DoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = Double
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let value = value else { return nil }
        if let double = value as? Double {
            return double
        } else if let int = value as? Int {
            return int.double
        } else if let bool = value as? Bool {
            return bool.double
        } else if let string = value as? String {
            return string.safeDouble
        } else if let number = value as? NSNumber {
            return number.doubleValue
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

// ******************************* MARK: - Singleton

public extension DoubleTransform {
    static let shared = DoubleTransform()
}
