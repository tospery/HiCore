//
//  Int+Core.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation

public extension Int {
    
    var kilobytesText: String {
        (self * 1024).bytesText
    }
    
    var bytesText: String {
        ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file)
    }
    
    var decimalText: String {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber.init(value: self)) ?? self.string
    }
    
    init?(any: Any?) {
        if let string = any as? String {
            self.init(string)
            return
        }
        if let number = any as? Int {
            self = number
            return
        }
        return nil
    }
}

extension UInt32 {
    public func ip(isBigEndian: Bool = false, isIPV4: Bool = true ) -> String {
        let ip = self
        let byte1 = UInt8(ip & 0xff)
        let byte2 = UInt8((ip>>8) & 0xff)
        let byte3 = UInt8((ip>>16) & 0xff)
        let byte4 = UInt8((ip>>24) & 0xff)
        if isBigEndian {
            return "\(byte1).\(byte2).\(byte3).\(byte4)"
        }
        return "\(byte4).\(byte3).\(byte2).\(byte1)"
    }
}

public extension UInt64 {
    var formatted: String {
        if self == 0 {
            return "0"
        }
        if self < 1000 {
            return "\(self)"
        }
        let num = fabs(Double(self))
        let exp: Int = Int(log10(num) / 3.0 )
        let units: [String] = ["K", "M", "G", "T", "P", "E"]
        let roundedNum: Double = round(10 * num / pow(1000.0, Double(exp))) / 10
        return "\(roundedNum)\(units[exp-1])"
    }
}
