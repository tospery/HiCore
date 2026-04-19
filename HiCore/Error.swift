//
//  HiError.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import SwifterSwift

public struct ErrorCode {
    public static let ok                        = 200
}

public enum HiError: Error {
    case none
    case cancel
    case unknown
    case timeout
    case navigation
    case dataInvalid
    case dataIsEmpty
    case networkNotConnected    // 网络不可用
    case networkNotReachable    // 服务不可达
    case userNotLoginedIn       // 对应HTTP的401
    case userLoginExpired       // 将自己服务器的错误码转换为该值
    case server(Int, String?, [String: Any]?)
    case app(String, Int, String?, [String: Any]?)
}

extension HiError: Identifiable {
    public var id: String { localizedDescription }
}

extension HiError: CustomNSError {
    public static let domain = Bundle.main.bundleIdentifier ?? ""
    public var errorCode: Int {
        switch self {
        case .none: return 0
        case .cancel: return 1
        case .unknown: return 2
        case .timeout: return 3
        case .navigation: return 4
        case .dataInvalid: return 5
        case .dataIsEmpty: return 6
        case .networkNotConnected: return 7
        case .networkNotReachable: return 8
        case .userNotLoginedIn: return 9
        case .userLoginExpired: return 10
        case let .server(code, _, _): return code
        case let .app(_, code, _, _): return code
        }
    }
}

extension HiError: LocalizedError {
    /// 概述
    public var failureReason: String? {
        var reason: String?
        switch self {
        case .none:
            reason = "Error.None.Title"
        case .cancel:
            reason = "Error.Cancel.Title"
        case .unknown:
            reason = "Error.Unknown.Title"
        case .timeout:
            reason = "Error.Timeout.Title"
        case .navigation:
            reason = "Error.Navigation.Title"
        case .dataInvalid:
            reason = "Error.DataInvalid.Title"
        case .dataIsEmpty:
            reason = "Error.ListIsEmpty.Title"
        case .networkNotConnected:
            reason = "Error.Network.NotConnected.Title"
        case .networkNotReachable:
            reason = "Error.Network.NotReachable.Title"
        case .userNotLoginedIn:
            reason = "Error.User.NotLoginedIn.Title"
        case .userLoginExpired:
            reason = "Error.User.LoginExpired.Title"
        case let .server(code, _, _):
            var result = "Error.Server.Title\(code)"
            if result.starts(with: "Error.Server.Title") {
                result = "Error.Server.Title"
            }
            reason = result
        case let .app(domain, code, _, _):
            let prefix = "Error.App.\(domain.capitalizedFirstCharacter).Title"
            var result = "\(prefix)\(code)"
            if result.starts(with: prefix) {
                result = prefix
            }
            reason = result
        }
        return reason?.localized()
    }
    /// 详情（localizedDescription）
    public var errorDescription: String? {
        var desc: String?
        switch self {
        case .none:
            desc = "Error.None.Message"
        case .cancel:
            desc = "Error.Cancel.Message"
        case .unknown:
            desc = "Error.Unknown.Message"
        case .timeout:
            desc = "Error.Timeout.Message"
        case .navigation:
            desc = "Error.Navigation.Message"
        case .dataInvalid:
            desc = "Error.DataInvalid.Message"
        case .dataIsEmpty:
            desc = "Error.ListIsEmpty.Message"
        case .networkNotConnected:
            desc = "Error.Network.NotConnected.Message"
        case .networkNotReachable:
            desc = "Error.Network.NotReachable.Message"
        case .userNotLoginedIn:
            desc = "Error.User.NotLoginedIn.Message"
        case .userLoginExpired:
            desc = "Error.User.LoginExpired.Message"
        case let .server(code, message, _):
            var result = message ?? "Error.Server.Message\(code)"
            if result.starts(with: "Error.Server.Message") {
                result = "Error.Server.Message"
            }
            desc = result
        case let .app(domain, code, message, _):
            let prefix = "Error.App.\(domain.capitalizedFirstCharacter).Message"
            var result = message ?? "\(prefix)\(code)"
            if result.starts(with: prefix) {
                result = prefix
            }
            desc = result
        }
        return desc?.localized()
    }
    /// 重试
    public var recoverySuggestion: String? {
        var suggestion: String?
        switch self {
        case let .app(domain, code, _, _):
            suggestion = "Error.App.\(domain).Suggestion\(code)"
        default:
            break
        }
        if suggestion?.hasPrefix("Error.") ?? false {
            suggestion = nil
        }
        return suggestion?.localized()
    }
}

extension HiError: Equatable {
    public static func == (lhs: HiError, rhs: HiError) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.unknown, .unknown),
            (.timeout, .timeout),
             (.navigation, .navigation),
             (.dataInvalid, .dataInvalid),
             (.dataIsEmpty, .dataIsEmpty),
            (.networkNotConnected, .networkNotConnected),
            (.networkNotReachable, .networkNotReachable),
            (.userNotLoginedIn, .userNotLoginedIn),
           (.userLoginExpired, .userLoginExpired):
            return true
        case (.server(let left, _, _), .server(let right, _, _)):
            return left == right
        case (.app(let leftDomain, let leftCode, _, _), .app(let rightDomain, let rightCode, _, _)):
            return (leftDomain == rightDomain) && (leftCode == rightCode)
        default: return false
        }
    }
}

extension HiError: CustomStringConvertible {
    public var description: String {
        var desc: String?
        switch self {
        case .none: desc = "HiError.none"
        case .cancel: desc = "HiError.cancel"
        case .unknown: desc = "HiError.unknown"
        case .timeout: desc = "HiError.timeout"
        case .navigation: desc = "HiError.navigation"
        case .dataInvalid: desc = "HiError.dataInvalid"
        case .dataIsEmpty: desc = "HiError.dataIsEmpty"
        case .networkNotConnected: desc = "HiError.networkNotConnected"
        case .networkNotReachable: desc = "HiError.networkNotReachable"
        case .userNotLoginedIn: desc = "HiError.userNotLoginedIn"
        case .userLoginExpired: desc = "HiError.userLoginExpired"
        case let .server(code, message, extra): desc = "HiError.server(\(code), \(message ?? ""), \(extra?.jsonString() ?? "")"
        case let .app(domain, code, message, extra): desc = "HiError.app.\(domain)(\(code), \(message ?? ""), \(extra?.jsonString() ?? ""))"
        }
        return desc?.localized() ?? ""
    }
}

extension HiError {
    
    public var isNetwork: Bool {
        self == .networkNotConnected || self == .networkNotReachable
    }

    public var isNeedLogin: Bool {
        self == .userNotLoginedIn || self == .userLoginExpired
    }
    
    public func isServerError(withCode errorCode: Int) -> Bool {
        if case let .server(code, _, _) = self {
            return errorCode == code
        }
        return false
    }
    
    public func isAppError(forDomain errorDomain: String, withCode errorCode: Int) -> Bool {
        if case let .app(domain, code, _, _) = self {
            return (errorDomain == domain) && (errorCode == code)
        }
        return false
    }
    
}

public protocol HiErrorCompatible {
    var hiError: HiError { get }
}

extension Error {
    
    public var asHiError: HiError {
        if let hi = self as? HiError {
            return hi
        }
        if let compatible = self as? HiErrorCompatible {
            return compatible.hiError
        }
        return .server(0, self.localizedDescription, nil)
    }

}

public enum MappingError: Error {
    case emptyData
    case invalidJSON(message: String)
    case unknownType
}
extension MappingError: HiErrorCompatible {
    public var hiError: HiError {
        switch self {
        case .unknownType: return .unknown
        case .emptyData: return .dataIsEmpty
        case .invalidJSON: return .dataInvalid
        }
    }
}
