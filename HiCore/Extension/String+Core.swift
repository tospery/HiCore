//
//  String+Core.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import UIKit
import SwiftUI
import SwifterSwift
import HiBase

public extension String {
    
    // MARK: - Properties
    var chineseLocalizedString: String { NSLocalizedString(self, bundle: Bundle.zhBundle ?? .main, comment: "") }
    var englishLocalizedString: String { NSLocalizedString(self, bundle: Bundle.enBundle ?? .main, comment: "") }
    
    var capitalizedFirstCharacter: String {
        guard let first = first else { return self }
        return String(first).uppercased() + dropFirst()
    }
    
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
    
    var color: UIColor? {
        let string = self.removingPrefix("0x").removingPrefix("#")
        if string.count == 6 {
            return .init(hexString: self)
        }
        if string.count == 8 {
            var hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)
            hexString = hexString.removingPrefix("0x").removingPrefix("#")
            
            guard hexString.count == 8 else { return nil }
            
            let rString = String(hexString.prefix(2))
            let gString = String(hexString.dropFirst(2).prefix(2))
            let bString = String(hexString.dropFirst(4).prefix(2))
            let aString = String(hexString.dropFirst(6).prefix(2))
            
            var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0, a: UInt64 = 0
            Scanner(string: rString).scanHexInt64(&r)
            Scanner(string: gString).scanHexInt64(&g)
            Scanner(string: bString).scanHexInt64(&b)
            Scanner(string: aString).scanHexInt64(&a)
            
            return UIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: CGFloat(a) / 255.0
            )
        }
        return nil
    }
    
    var swiftUIColor: Color? {
        self.color?.swiftUIColor
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
    
    var isValidBackUrl: Bool {
        guard let url = self.url else { return false }
        return ["back"].contains((url.host() ?? "").lowercased())
    }
    
    var isValidOpenUrl: Bool {
        guard let url = self.url else { return false }
        return [
            "toast", "alert", "sheet", "popup", "logic"
        ].contains((url.host() ?? "").lowercased())
    }
    
    var isValidToastUrl: Bool {
        guard let url = self.url else { return false }
        return ["toast"].contains((url.host() ?? "").lowercased())
    }
    
    var isValidAlertUrl: Bool {
        guard let url = self.url else { return false }
        return ["alert"].contains((url.host() ?? "").lowercased())
    }
    
    var isValidSheetUrl: Bool {
        guard let url = self.url else { return false }
        return ["sheet"].contains((url.host() ?? "").lowercased())
    }
    
    var isValidPopupUrl: Bool {
        guard let url = self.url else { return false }
        return ["popup"].contains((url.host() ?? "").lowercased())
    }
    
    var isValidLogicUrl: Bool {
        guard let url = self.url else { return false }
        return ["logic"].contains((url.host() ?? "").lowercased())
    }
    
    var isValidLoginUrl: Bool {
        guard let url = self.url else { return false }
        return ["login"].contains((url.host() ?? "").lowercased())
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
    
    var imageSource: ImageSource? {
        if self.hasPrefix("http") {
            return self.url
        }
        return UIImage.init(named: self)
    }
        
    init<Subject>(fullname subject: Subject) {
        self.init(reflecting: subject)
        if let displayName = UIApplication.shared.displayName {
            self = self.replacingOccurrences(of: "\(displayName).", with: "")
        }
        self = self.replacingOccurrences(of: UIApplication.shared.bundleName + ".", with: "")
        self = self.replacingOccurrences(of: "HiCore.", with: "")
    }
    
    var hashColor: UIColor {
        let hashValue = self.hashValue
        let red = CGFloat((hashValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hashValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hashValue & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
 
    var image: UIImage? { .init(named: self) }
    
    var swiftUIImage: SwiftUI.Image? { .init(self) }
    
}
