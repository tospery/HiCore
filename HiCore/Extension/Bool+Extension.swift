//
//  Bool+Extension.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation

extension Bool {
    
    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Bool? {
        if string.isNil {
            print("[\(file.fileName):\(line)] Received '\(string)' string instead of a Bool. Considering it as `nil`.")
            return nil
        }
        
        if let bool = string.asBool {
            return bool
        } else {
            print("Unable to cast String to Bool: \ndata = \(["string": string])")
            return nil
        }
    }

}
