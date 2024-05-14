//
//  Double+Extension.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation

extension Double {
    
    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Double? {
        if string.isNil {
            print("[\(file.fileName):\(line)] Received '\(string)' string instead of a Double. Considering it as `nil`.")
            return nil
        }
        
        if let double = Double(string) {
            return double
        } else {
            print("Unable to cast String to Double: \ndata = \(["string": string])")
            return nil
        }
    }
    
}
