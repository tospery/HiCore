//
//  String+Core.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import SwifterSwift

private let kSpaceCharacter = Character(" ")
private let kNewLineCharacter = Character("\n")

public extension String {
    
    var isNil: Bool {
        isEmpty || self == "-"
    }
    
    var safeDouble: Double? {
        if self.isNil {
            return nil
        }
        return Double(self)
    }
    
    var safeInt: Int? {
        if self.isNil {
            return nil
        }
        if let int = self.int {
            return int
        } else if let double = self.safeDouble {
            return double.safeInt
        }
        return nil
    }
    
    var safeBool: Bool? {
        if self.isNil {
            return nil
        }
        return self.forceBool
    }
    
    var forceBool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1", "enable":
            return true
        case "false", "no", "0", "disable":
            return false
        default:
            return nil
        }
    }
    
    var firstNonWhitespaceCharacter: Character? {
        guard let index = firstIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        return self[index]
    }
    
    var secondNonWhitespaceCharacter: Character? {
        guard let firstIndex = firstIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
                
        let secondIndex = index(after: firstIndex)
        guard secondIndex < endIndex else { return nil }
        
        return self[secondIndex]
    }
    
    var lastNonWhitespaceCharacter: Character? {
        guard let index = lastIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        return self[index]
    }
    
    var beforeLastNonWhitespaceCharacter: Character? {
        guard let lastIndex = lastIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        
        let beforeLastIndex = index(before: lastIndex)
        guard startIndex <= beforeLastIndex else { return nil }
        
        return self[beforeLastIndex]
    }
    
    /// Returns fileName without extension
    var fileName: String {
        guard let lastPathComponent = components(separatedBy: "/").last else { return "" }
        
        var components = lastPathComponent.components(separatedBy: ".")
        if components.count == 1 {
            return lastPathComponent
        } else {
            components.removeLast()
            return components.joined(separator: ".")
        }
    }
    
    // MARK: - Properties
    var forcedURL: URL? {
        var url = URL.init(string: self)
        if url == nil {
            let raw = self.trimmed
            url = URL.init(string: raw)
            if url == nil {
                url = URL.init(string: raw.urlDecoded)
            }
            if url == nil {
                url = URL.init(string: raw.urlEncoded)
            }
        }
        return url
    }
    
    var isNotEmpty: Bool { !isEmpty }
    
    var color: UIColor? {
        return UIColor(hexString: self)
    }
    
    var method: String {
        self.replacingOccurrences(of: "/", with: " ").camelCased
    }
    
    var emptyToNil: String? {
        self.isEmpty ? nil : self
    }
    
    var urlPlaceholderValue: String {
        guard self.hasPrefix("<") else { return self }
        guard self.hasSuffix(":_>") else { return self }
        return self.removingPrefix("<").removingPrefix(":_>")
    }
    
    var camelCasedWithoutUnderline: String {
        var result = ""
        let cmps = self.components(separatedBy: "_")
        for (index, cmp) in cmps.enumerated() {
            if index == 0 {
                result += cmp.lowercased()
            } else {
                result += cmp.lowercased().capitalized
            }
        }
        return result
    }
    
    var fileExt: String? { self.url?.pathExtension }

    var apiString: String {
        (try? NSRegularExpression.init(pattern: "(\\{[^\\}]+\\})"))?.stringByReplacingMatches(
            in: self,
            range: .init(location: 0, length: self.count),
            withTemplate: ""
        ) ?? self
    }
    
    // MARK: - Methods
    func nsRange(from range: Range<String.Index>) -> NSRange {
        .init(range, in: self)
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else {
            return nil
        }
        return from ..< to
    }
    
    func matched(pattern: String, options: NSRegularExpression.Options = [], wrapped: Bool = false) -> [String] {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return [] }
        var results = [String].init()
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        for match in matches {
            if let range = Range(wrapped ? match.range(at: 1) : match.range, in: self) {
                let string = String(self[range])
                if string.isNotEmpty {
                    results.append(string)
                }
            }
        }
        return results
    }
    
    func splitString(by maxLength: Int) -> [String] {
        var result = [String]()
        let utf8 = self.utf8
        var start = utf8.startIndex
        var end = utf8.startIndex

        while end != utf8.endIndex {
            let nextIndex = utf8.index(end, offsetBy: maxLength, limitedBy: utf8.endIndex) ?? utf8.endIndex
            let range = start..<nextIndex
            if let subString = String(utf8[range]) {
                result.append(subString)
            }
            start = nextIndex
            end = nextIndex
        }

        return result
    }
    
    func found(pattern: String, options: NSRegularExpression.Options = [], count: Int = 1) -> [String] {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return [] }
        var results = [String].init()
        if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            for index in 1...count {
                if let range = Range(match.range(at: index), in: self) {
                    let string = String(self[range])
                    results.append(string)
                }
            }
        }
        return results
    }
    
    var ipValue: UInt32 {
        let array = self.components(separatedBy: ".")
        if array.count != 4 {
            return 0
        }
        let seg1 = Int(array[0]) ?? 0
        let seg2 = Int(array[1]) ?? 0
        let seg3 = Int(array[2]) ?? 0
        let seg4 = Int(array[3]) ?? 0
        
        var value: UInt32 = 0
        value |= UInt32((seg1 & 0xff) << 24)
        value |= UInt32((seg2 & 0xff) << 16)
        value |= UInt32((seg3 & 0xff) << 8)
        value |= UInt32((seg4 & 0xff) << 0)
        return value
    }
    
    var isValidPDFUrl: Bool {
        guard let url = self.url else { return false }
        return [
            "pdf"
        ].contains(url.pathExtension.lowercased())
    }
    
    var isValidImageUrl: Bool {
        guard let url = self.url else { return false }
        return [
            "jpg", "jpeg", "png", "gif", "svg", "bmp", "webp"
        ].contains(url.pathExtension.lowercased())
    }
    
    var isValidMarkdownUrl: Bool {
        guard let url = self.url else { return false }
        return [
            "md", "mdx"
        ].contains(url.pathExtension.lowercased())
    }
    
}

//extension StringProtocol {
//    
//    /// Returns `self` as `Bool` if conversion is possible.
//    var asBool: Bool? {
//        if let bool = Bool(asString) {
//            return bool
//        }
//        
//        switch lowercased() {
//        case "true", "yes", "1", "enable": return true
//        case "false", "no", "0", "disable": return false
//        default: return nil
//        }
//    }
//    
//    /// Returns `self` as `String`
//    var asString: String {
//        if let string = self as? String {
//            return string
//        } else {
//            return String(self)
//        }
//    }
//    
//}
