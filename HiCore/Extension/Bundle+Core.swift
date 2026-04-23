//
//  Bundle+Core.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import HiBase

public extension Bundle {
    
    convenience init?(module: String) {
        self.init(identifier: "org.cocoapods." + module)
    }

}
