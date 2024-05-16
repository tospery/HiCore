//
//  ModelType.swift
//  HiIOS
//
//  Created by 杨建祥 on 2022/7/18.
//

import Foundation
import ObjectMapper
import SwifterSwift

public protocol ModelType: Identifiable, Codable, Hashable, CustomStringConvertible, Mappable {
    var isValid: Bool { get }
    init()
}

public extension ModelType {

    var isValid: Bool {
        let string = tryString(self.id) ?? ""
        if !string.isEmpty {
            return true
        }
        let int = tryInt(self.id) ?? 0
        if int != 0 {
            return true
        }
        return false
    }
    
    var description: String { self.toJSONString() ?? String(describing: self.id.hashValue) }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

}

public struct WrappedModel: ModelType {

    public var id = 0
    public var data: Any?
    
    public var isValid: Bool { self.data != nil }
    
    public init() {
    }
    
    public init(_ data: Any? = nil) {
        self.data = data
    }
    
    public init?(map: Map) {
    }
    
    public mutating func mapping(map: Map) {
        data    <- map["data"]
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }
    
    public var description: String {
        String.init(describing: self.data)
    }

    enum CodingKeys: String, CodingKey {
        case id, data
    }
    
    public func encode(to encoder: Encoder) throws { }

    public init(from decoder: Decoder) throws { }
    
}

public struct ModelContext: MapContext {
    
    public let shouldMap: Bool
    
    public init(shouldMap: Bool = true){
        self.shouldMap = shouldMap
    }

}


