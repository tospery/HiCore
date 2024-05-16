//
//  TypeCastTransform.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import ObjectMapper

/// Transforms value of type Any to generic type. Tries to typecast if possible.
public class TypeCastTransform<T>: TransformType {
    public typealias Object = T
    public typealias JSON = T
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        guard let value = value else { return nil }
        if let value = value as? T {
            return value
        } else if T.self == Int.self {
            return IntTransform.shared.transformFromJSON(value) as? T
        } else if T.self == Double.self {
            return DoubleTransform.shared.transformFromJSON(value) as? T
        } else if T.self == Bool.self {
            return BoolTransform.shared.transformFromJSON(value) as? T
        } else if T.self == String.self {
            return StringTransform.shared.transformFromJSON(value) as? T
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
