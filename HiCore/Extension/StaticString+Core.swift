//
//  StaticString+Core.swift
//  Pods
//
//  Created by 杨建祥 on 2024/12/20.
//

import UIKit
import SwiftUI
import SwifterSwift
import HiBase

public extension StaticString {
    
    var chineseLocalizedString: String { NSLocalizedString(self.description, bundle: Bundle.zhBundle ?? .main, comment: "") }
    var englishLocalizedString: String { NSLocalizedString(self.description, bundle: Bundle.enBundle ?? .main, comment: "") }
    
}
