//
//  Bool+Core.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation

public extension Bool {
    
    var double: Double {
        (self ? 1.0 : 0.0)
    }
    
//    static func safeFrom(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) -> Bool? {
//        if string.isNil {
//            return nil
//        }
//        
//        if let bool = string.asBool {
//            return bool
//        } else {
//            return nil
//        }
//    }

}
