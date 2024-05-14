//
//  BaseMappable+Additions.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation
import ObjectMapper

public extension BaseMappable {
    func toJSON(shouldIncludeNilValues: Bool) -> [String: Any] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSON(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }
}

public extension Array where Element: BaseMappable {
    func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONArray(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }

}

public extension Set where Element: BaseMappable {
    func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONSet(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }
}
