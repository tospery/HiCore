//
//  HiError.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation

var appLanguageBundle: Bundle?
public var appLanguageCodes: [String]? {
    didSet {
        if let code = appLanguageCodes?.first,
           let path = Bundle.main.path(forResource: code, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            appLanguageBundle = bundle
        }
    }
}

//        NSURLErrorTimedOut(-1001): 请求超时
//        NSURLErrorCannotConnectToHost(-1004): 找不到服务
//        NSURLErrorDataNotAllowed(-1020): 网络不可用
public struct ErrorCode {
    public static let ok                        = 200
    public static let serverUnableConnect       = -10001
    public static let serverInternalError       = -10002
    public static let serverNoResponse          = -10003
    public static let nserror                   = -20001
    public static let skerror                   = -20002
    public static let rxerror                   = -20003
    public static let aferror                   = -20004
    public static let moyaError                 = -20005
    public static let asError                   = -20006
    public static let kfError                   = -20007
    public static let appError                  = -30000
    public static let mapping                   = -40000
    public static let netError                  = -50000
}

public enum HiError: Error {
    case none
    case cancel
    case unknown
    case timeout
    case navigation
    case dataInvalid
    case listIsEmpty
    case networkNotConnected
    case networkNotReachable
    case userNotLoginedIn   // 对应HTTP的401
    case userLoginExpired   // 将自己服务器的错误码转换为该值
    case server(Int, String?, [String: Any]?)
    case app(Int, String?, [String: Any]?)
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
        case .listIsEmpty: return 6
        case .networkNotConnected: return 7
        case .networkNotReachable: return 8
        case .userNotLoginedIn: return 9
        case .userLoginExpired: return 10
        case let .server(code, _, _): return code
        case let .app(code, _, _): return code
        }
    }
}

extension HiError: LocalizedError {
    /// 概述
    public var failureReason: String? {
        switch self {
        case .none:
            return "Error.None.Title"
        case .cancel:
            return "Error.Cancel.Title"
        case .unknown:
            return "Error.Unknown.Title"
        case .timeout:
            return "Error.Timeout.Title"
        case .navigation:
            return "Error.Navigation.Title"
        case .dataInvalid:
            return "Error.DataInvalid.Title"
        case .listIsEmpty:
            return "Error.ListIsEmpty.Title"
        case .networkNotConnected:
            return "Error.Network.NotConnected.Title"
        case .networkNotReachable:
            return "Error.Network.NotReachable.Title"
        case .userNotLoginedIn:
            return "Error.User.NotLoginedIn.Title"
        case .userLoginExpired:
            return "Error.User.LoginExpired.Title"
        case let .server(code, _, _):
            var result = "Error.Server.Title\(code)"
            if result.starts(with: "Error.Server.Title") {
                result = "Error.Server.Title"
            }
            return result
        case let .app(code, _, _):
            var result = "Error.App.Title\(code)"
            if result.starts(with: "Error.App.Title") {
                result = "Error.App.Title"
            }
            return result
        }
    }
    /// 详情
    public var errorDescription: String? {
        switch self {
        case .none:
            return "Error.None.Message"
        case .cancel:
            return "Error.Cancel.Message"
        case .unknown:
            return "Error.Unknown.Message"
        case .timeout:
            return "Error.Timeout.Message"
        case .navigation:
            return "Error.Navigation.Message"
        case .dataInvalid:
            return "Error.DataInvalid.Message"
        case .listIsEmpty:
            return "Error.ListIsEmpty.Message"
        case .networkNotConnected:
            return "Error.Network.NotConnected.Message"
        case .networkNotReachable:
            return "Error.Network.NotReachable.Message"
        case .userNotLoginedIn:
            return "Error.User.NotLoginedIn.Message"
        case .userLoginExpired:
            return "Error.User.LoginExpired.Message"
        case let .server(code, message, _):
            var result = message ?? "Error.Server.Message\(code)"
            if result.starts(with: "Error.Server.Message") {
                result = "Error.Server.Message"
            }
            return result
        case let .app(code, message, _):
            var result = message ?? "Error.App.Message\(code)"
            if result.starts(with: "Error.App.Message") {
                result = "Error.App.Message"
            }
            return result
        }
    }
    /// 重试
    public var recoverySuggestion: String? {
        var suggestion: String?
        switch self {
        case let .app(code, _, _):
            suggestion = "Error.App.Suggestion\(code)"
        default:
            break
        }
        if suggestion?.hasPrefix("Error.") ?? false {
            suggestion = nil
        }
        return suggestion
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
             (.listIsEmpty, .listIsEmpty),
            (.networkNotConnected, .networkNotConnected),
            (.networkNotReachable, .networkNotReachable),
            (.userNotLoginedIn, .userNotLoginedIn),
           (.userLoginExpired, .userLoginExpired):
            return true
        case (.server(let left, _, _), .server(let right, _, _)),
             (.app(let left, _, _), .app(let right, _, _)):
            return left == right
        default: return false
        }
    }
}

extension HiError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none: return "HiError.none"
        case .cancel: return "HiError.cancel"
        case .unknown: return "HiError.unknown"
        case .timeout: return "HiError.timeout"
        case .navigation: return "HiError.navigation"
        case .dataInvalid: return "HiError.dataInvalid"
        case .listIsEmpty: return "HiError.listIsEmpty"
        case .networkNotConnected: return "HiError.networkNotConnected"
        case .networkNotReachable: return "HiError.networkNotReachable"
        case .userNotLoginedIn: return "HiError.userNotLoginedIn"
        case .userLoginExpired: return "HiError.userLoginExpired"
        case let .server(code, message, extra): return "HiError.server(\(code), \(message ?? ""), \(extra?.jsonString() ?? "")"
        case let .app(code, message, extra): return "HiError.app(\(code), \(message ?? ""), \(extra?.jsonString() ?? ""))"
        }
    }
}

extension HiError {
    
    public var isNetwork: Bool {
        self == .networkNotConnected || self == .networkNotReachable
    }

//    public var isServer: Bool {
//        if case .server = self {
//            return true
//        }
//        return false
//    }
//
//    public var isCancel: Bool {
//        self == .cancel
//    }
//
//    public var isListIsEmpty: Bool {
//        self == .dataIsEmpty
//    }

    public var isNeedLogin: Bool {
        self == .userNotLoginedIn || self == .userLoginExpired
    }
    
    public func isServerError(withCode errorCode: Int) -> Bool {
        if case let .server(code, _, _) = self {
            return errorCode == code
        }
        return false
    }
    
    public func isAppError(withCode errorCode: Int) -> Bool {
        if case let .app(code, _, _) = self {
            return errorCode == code
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
        default: return .dataInvalid
        }
    }
}
