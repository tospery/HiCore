//
//  DataType.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation

public struct Metric {
    
    public struct Tile {
        public static let spaceHeight       = 20.f
        public static let buttonHeight      = 44.f
        public static let cellHeight        = 50.f
        public static let titleFontSize     = 16.f
        public static let detailFontSize    = 14.f
        public static let margin = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 10)
        public static let padding = UIOffset.init(horizontal: 10, vertical: 8)
    }
    
}

public enum HiToastStyle: Int {
    case success
    case failure
    case warning
}

public enum HiPagingStyle: Int, Codable {
    case basic
    case navigationBar
    case pageViewController
}

public enum Localization: String, Codable {
    case chinese    = "zh-Hans"
    case english    = "en"
    
    public static let allValues = [chinese, english]
    
    public var preferredLanguages: [String]? {
        [self.rawValue]
    }
}

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

public enum MappingError: Error {
    case emptyData
    case invalidJSON(message: String)
    case unknownType
}
