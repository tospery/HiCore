//
//  UIDevice+Core.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import UIKit
import UICKeyChainStore
import FCUUID
import DeviceKit

public extension UIDevice {

    /// 如 iPhone12,5、iPad6,8
    var deviceModel: String { Device.identifier }
    
    /// 如 iPhone 11 Pro Max、iPad Pro (12.9 inch)，如果是模拟器，会在后面带上“ Simulator”字样。
    var deviceName: String {
        let device = Device.current
        switch device {
        case .simulator(let model): return "(\(model.safeDescription)) Simulator"
        default: return device.safeDescription
        }
    }
    
    var keychain: UICKeyChainStore {
        let service = "device.info"
        let accessGroup = UIApplication.shared.team + ".shared"
        let keychain = UICKeyChainStore(service: service, accessGroup: accessGroup)
        return keychain
    }

    var uuid: String {
        let keychain = self.keychain
        let key = "uuid"
        var uuid = keychain[key]
        if uuid?.isEmpty ?? true {
            uuid = FCUUID.uuidForDevice()
            keychain[key] = uuid
        }
        return uuid!
    }

}
