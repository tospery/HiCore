//
//  Double+Extension.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

import Foundation

extension Double {
    
    var bool: Bool {
        return self != 0
    }
    
    var safeInt: Int? {
        let roundedDouble = self.rounded()
        return Int(exactly: roundedDouble)
    }
    
}
