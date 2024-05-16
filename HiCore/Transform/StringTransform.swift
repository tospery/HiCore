//
//  StringTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper
import SwifterSwift

/// Transforms value of type Any to String. Tries to typecast if possible.
public class StringTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    private init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let value = value else { return nil }
        if let string = value as? String {
            return string
        } else if let int = value as? Int {
            return int.string
        } else if let double = value as? Double {
            return double.string
        } else if let bool = value as? Bool {
            return bool.string
        } else if let number = value as? NSNumber {
            return number.stringValue
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

// ******************************* MARK: - Singleton
public extension StringTransform {
    static let shared = StringTransform()
}
