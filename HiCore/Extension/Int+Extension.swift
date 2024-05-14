//
//  Int+Extension.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation

extension Int {
    
    static func safeFrom(_ double: Double, file: String = #file, function: String = #function, line: UInt = #line) -> Int? {
        let roundedDouble = double.rounded()
        if let int = Int(exactly: roundedDouble) {
            if roundedDouble != double {
                print("[\(file.fileName):\(line)] Double casted to Int with rounding: \(double) -> \(int)")
            }
            
            return int
            
        } else {
            print("Unable to cast Double to Int: \ndata = \(["double": double])")
            return nil
        }
    }
    
    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Int? {
        if string.isNil {
            print("[\(file.fileName):\(line)] Received '\(string)' string instead of an Int. Considering it as `nil`.")
            return nil
        }
        
        if let int = Int(string) {
            return int
            
        } else if let double = Double.safeFrom(string, file: file, function: function, line: line) {
            return safeFrom(double, file: file, function: function, line: line)
            
        } else {
            print("Unable to cast String to Int: \ndata = \(["string": string])")
            return nil
        }
    }
}
