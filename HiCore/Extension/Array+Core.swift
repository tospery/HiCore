//
//  Array+Core.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import ObjectMapper

// ******************************* MARK: - Array - Generics
public extension Array {
    
    var sortedJSONString: String {
        let temp = self
        var strings = [String].init()
        for value in temp {
            if let dictionary = value as? [String: Any] {
                strings.append(dictionary.sortedJSONString)
            } else if let array = value as? [Any] {
                strings.append(array.sortedJSONString)
            } else {
                strings.append("\"\(value)\"")
            }
        }
        strings.sort { $0 < $1 }
        var result = "["
        result += strings.joined(separator: ",")
        result += "]"
        return result
    }
    
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
}

public extension Array where Element: BaseMappable {
    /// Returns the JSON String for the object
    func toJSONString(options: JSONSerialization.WritingOptions) -> String? {
        let dictionary = Mapper<Element>().toJSONArray(self)
        return Mapper<Element>.toJSONData(dictionary, options: options)?.utf8String
    }
}

// ******************************* MARK: - Array - BaseMappable(data)
public extension Array where Element: BaseMappable {
    
    func toJSON(shouldIncludeNilValues: Bool) -> [[String: Any]] {
        return Mapper(shouldIncludeNilValues: shouldIncludeNilValues).toJSONArray(self)
    }
    
    /// Returns the JSON Data for the object
    func toJSONData() -> Data? {
        toJSONString(prettyPrint: false)?.data(using: .utf8)
    }
    
    /// Creates models array from JSON string.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) throws -> Array {
        guard let jsonData = jsonData, !jsonData.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonData.firstNonWhitespaceByte == ASCIICodes.openSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonData.lastNonWhitespaceByte == ASCIICodes.closeSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let jsonObject = jsonData.safeSerializeToJSON(file: file, function: function, line: line) else {
            throw MappingError.invalidJSON(message: "Unable to serialize JSON array from the data")
        }
        
        guard let jsonArrayOfDictionaries = jsonObject as? [[String: Any]] else {
            throw MappingError.unknownType
        }
        
        let array = Mapper<Element>().mapArray(JSONArray: jsonArrayOfDictionaries)
        
        return array
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    static func safeCreate(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) -> Array? {
        do {
            return try create(jsonData: jsonData)
        } catch {
            print("Unable to create array of objects from JSON data: \nerror = \(error)\ndata: \(["jsonData": jsonData?.asString])")
            return nil
        }
    }
}

// ******************************* MARK: - Array - BaseMappable(string)
public extension Array where Element: BaseMappable {
    
    /// Creates models array from JSON string.
    /// - parameter jsonString: String in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) throws -> Array {
        guard let jsonString = jsonString else {
            throw MappingError.emptyData
        }
        
        guard !jsonString.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonString.firstNonWhitespaceCharacter == "[" else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonString.lastNonWhitespaceCharacter == "]" else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let array = Mapper<Element>().mapArray(JSONString: jsonString) else {
            throw MappingError.unknownType
        }
        
        return array
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonString: String in JSON format to use for model creation.
    static func safeCreate(jsonString: String?, file: String = #file, function: String = #function, line: UInt = #line) -> Array? {
        do {
            return try create(jsonString: jsonString)
        } catch {
            print("Unable to create array of objects from JSON string: \nerror = \(error)\ndata = \(["jsonString": jsonString ?? .init(), "self": self])")
            return nil
        }
    }
}

// ******************************* MARK: - Array - OptionalType(data)
public extension Array where Element: OptionalType, Element.Wrapped: BaseMappable {
    
    /// Creates models array from JSON string.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    /// - throws: `MappingError.emptyData` if response data is empty.
    /// - throws: `MappingError.invalidJSON` if response isn't a valid JSON.
    /// - throws: `MappingError.unknownType` if it wasn't possible to create model.
    static func create(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) throws -> [Element] {
        guard let jsonData = jsonData, !jsonData.isEmpty else {
            throw MappingError.emptyData
        }
        
        // Start check
        guard jsonData.firstNonWhitespaceByte == ASCIICodes.openSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should start with the '[' character")
        }
        
        // End check
        guard jsonData.lastNonWhitespaceByte == ASCIICodes.closeSquareBracket else {
            throw MappingError.invalidJSON(message: "JSON array should end with the ']' character")
        }
        
        guard let jsonObject = jsonData.safeSerializeToJSON(file: file, function: function, line: line) else {
            throw MappingError.invalidJSON(message: "Unable to serialize JSON array from the data")
        }
        
        guard let jsonArrayOfObjects = jsonObject as? [Any] else {
            throw MappingError.unknownType
        }
        
        return try jsonArrayOfObjects.map { object in
            if object is NSNull {
                return Element(nilLiteral: ())
                
            } else {
                if let _jsonObject = object as? [String: Any],
                   let jsonObject = Mapper<Element.Wrapped>().map(JSON: _jsonObject) as? Element {
                    
                    return jsonObject
                    
                } else {
                    throw MappingError.unknownType
                }
            }
        }
    }
    
    /// Create models array from JSON string. Report error and return nil if unable.
    /// - parameter jsonData: Data in JSON format to use for model creation.
    static func safeCreate(jsonData: Data?, file: String = #file, function: String = #function, line: UInt = #line) -> Array? {
        do {
            return try create(jsonData: jsonData)
        } catch {
            print("Unable to create array of optional objects from JSON data: \nerror = \(error)\ndata = \(["jsonData": jsonData?.asString])")
            return nil
        }
    }
}
