//
//  Logger.swift
//  HiCore
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import SwiftyBeaver

public let logType = SwiftyBeaver.self
public let logger = Logger.init()

public protocol LoggerCompatible {
    
    func print(
        _ message: @autoclosure () -> Any,
        module: Logger.Module,
        level: Logger.Level,
        file: String,
        function: String,
        line: Int,
        context: Any?
    )
    
}

public struct Logger {

    public typealias Module = String
    
    public enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
    }
    
    public init() {
    }
    
    public func print(
        _ message: @autoclosure () -> Any,
        module: Module = .common,
        level: Level = .debug,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        if let compatible = self as? LoggerCompatible {
            compatible.print(
                message(),
                module: module,
                level: level,
                file: file,
                function: function,
                line: line,
                context: context
            )
        } else {
            logType.custom(
                level: .init(rawValue: level.rawValue) ?? .debug,
                message: "\(Thread.current)【\(module)】\(message())",
                file: file,
                function: function,
                line: line,
                context: context
            )
        }
    }

}

extension Logger.Module {
    
    public static var common: Logger.Module { "common" }
    public static var core: Logger.Module { "core" }
    public static var utils: Logger.Module { "utils" }
    public static var realm: Logger.Module { "realm" }
    public static var hiUIKit: Logger.Module { "HiUIKit" }
    public static var hiSwiftUI: Logger.Module { "HiSwiftUI" }
    public static var library: Logger.Module { "library" }
    public static var restful: Logger.Module { "restful" }
    public static var network: Logger.Module { "network" }
    public static var database: Logger.Module { "database" }
    public static var statistic: Logger.Module { "statistic" }
    
}

