//
//  DataType.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import ObjectMapper

// MARK: - Constant

// MARK: - Datatype
public protocol BooleanType {
    var boolValue: Bool { get }
}

extension Bool: BooleanType {
    public var boolValue: Bool { return self }
}

public enum HiRequestMode: Int {
    case load, refresh, loadMore, update, reload
}

// MARK: - Function

enum ASCIICodes {
    static let openCurlyBracket: UInt8 = "{".data(using: .ascii)!.first!
    static let closeCurlyBracket: UInt8 = "}".data(using: .ascii)!.first!
    static let openSquareBracket: UInt8 = "[".data(using: .ascii)!.first!
    static let closeSquareBracket: UInt8 = "]".data(using: .ascii)!.first!
    static let space: UInt8 = " ".data(using: .ascii)!.first!
    static let newLine: UInt8 = "\n".data(using: .ascii)!.first!
}

// Take from https://github.com/RxSwiftCommunity/RxOptional/blob/master/Sources/RxOptional/OptionalType.swift
// Originally from here: https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L30-L40
// Credit to Artsy and @ashfurrow
public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
    init(nilLiteral: ())
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? { self }
}


public func tryBool(_ value: Any?) -> Bool? { BoolTransform.shared.transformFromJSON(value) }
public func tryInt(_ value: Any?) -> Int? { IntTransform.shared.transformFromJSON(value) }
public func tryDouble(_ value: Any?) -> Double? { DoubleTransform.shared.transformFromJSON(value) }
public func tryString(_ value: Any?) -> String? { StringTransform.shared.transformFromJSON(value) }

// MARK: - Compare
public func compareVersion(_ version1: String, _ version2: String, amount: Int = 3) -> ComparisonResult {
    version1.compare(version2, options: .numeric)
}

public func compareModels(_ left: [[any Hashable]]?, _ right: [[any Hashable]]?) -> Bool {
    if left == nil && right == nil {
        return true
    }
    if left == nil && right != nil {
        return false
    }
    if left != nil && right == nil {
        return false
    }
    if left!.count != right!.count {
        return false
    }
    for (index1, array1) in left!.enumerated() {
        let array2 = right![index1]
        if array1.count != array2.count {
            return false
        }
        for (index2, model2) in array2.enumerated() {
            let model1 = array1[index2]
            // if model1 != model2 {
            if model1.hashValue != model2.hashValue {
                return false
            } else {
                let leftString = String.init(describing: model1)
                let rightString = String.init(describing: model2)
                if leftString != rightString {
                    return false
                }
            }
        }
    }
    return true
}

public func compareAny(_ left: Any?, _ right: Any?) -> Bool {
    let leftType = type(of: left)
    let rightType = type(of: right)
    if leftType != rightType {
        return false
    }
    if left == nil && right == nil {
        return true
    }
    if left == nil && right != nil {
        return false
    }
    if left != nil && right == nil {
        return false
    }
    if let leftHashable = left as? (any Hashable),
       let rightHashable = right as? any Hashable {
        return leftHashable.hashValue == rightHashable.hashValue
    }
    let leftString = String.init(describing: left!)
    let rightString = String.init(describing: right!)
    return leftString == rightString
}
