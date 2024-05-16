//
//  Data+Core.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation

public extension Data {
    
    // ******************************* MARK: - As
    
    /// Get HEX string from data. Can be used for sending APNS token to backend.
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Try to convert data to ASCII string
    var asciiString: String? {
        String(data: self, encoding: String.Encoding.ascii)
    }
    
    /// Try to convert data to UTF8 string
    var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    
    /// String representation for data.
    /// Try to decode as UTF8 string at first.
    /// Try to decode as ASCII string at second.
    /// Uses hex representation if data can not be represented as UTF8 or ASCII string.
    var asString: String {
        utf8String ?? asciiString ?? hexString
    }
    
    /// Try to serialize `self` to JSON object and report error if unable.
    func safeSerializeToJSON(file: String = #file, function: String = #function, line: UInt = #line) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        } catch {
            print("Unable to parse data to JSON: \nerror = \(error)\ndata = \(["data": asString])")
            return nil
        }
    }
    
    // ******************************* MARK: - Checks
    
    var firstNonWhitespaceByte: UInt8? {
        guard let index = firstIndex(where: { $0 != ASCIICodes.space && $0 != ASCIICodes.newLine }) else { return nil }
        return self[index]
    }
    var secondNonWhitespaceByte: UInt8? {
        guard let index = firstIndex(where: { $0 != ASCIICodes.space && $0 != ASCIICodes.newLine }),
              index + 1 < count else { return nil }
        
        return self[index + 1]
    }
    
    var lastNonWhitespaceByte: UInt8? {
        guard let index = lastIndex(where: { $0 != ASCIICodes.space && $0 != ASCIICodes.newLine }) else { return nil }
        return self[index]
    }
    
    var beforeLastNonWhitespaceByte: UInt8? {
        guard let index = lastIndex(where: { $0 != ASCIICodes.space && $0 != ASCIICodes.newLine }),
              index - 1 >= 0 else { return nil }
        
        return self[index - 1]
    }
    
    static func dataFromFile(withFilename filename: String, at bundleClass: AnyClass? = nil) -> Data? {
        let components = filename.components(separatedBy: ".")
        guard let name = components.first, let type = components.last else { return nil }
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main
        guard let path = bundle.path(forResource: name, ofType: type) else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
}
