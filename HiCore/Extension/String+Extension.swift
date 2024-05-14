//
//  String+Extension.swift
//  HiIOS
//
//  Created by 杨建祥 on 2024/5/13.
//

// ******************************* MARK: - Checks

private let kSpaceCharacter = Character(" ")
private let kNewLineCharacter = Character("\n")

extension String {
    
    var isNil: Bool {
        isEmpty || self == "-"
    }
    
    var firstNonWhitespaceCharacter: Character? {
        guard let index = firstIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        return self[index]
    }
    
    var secondNonWhitespaceCharacter: Character? {
        guard let firstIndex = firstIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
                
        let secondIndex = index(after: firstIndex)
        guard secondIndex < endIndex else { return nil }
        
        return self[secondIndex]
    }
    
    var lastNonWhitespaceCharacter: Character? {
        guard let index = lastIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        return self[index]
    }
    
    var beforeLastNonWhitespaceCharacter: Character? {
        guard let lastIndex = lastIndex(where: { $0 != kSpaceCharacter && $0 != kNewLineCharacter }) else { return nil }
        
        let beforeLastIndex = index(before: lastIndex)
        guard startIndex <= beforeLastIndex else { return nil }
        
        return self[beforeLastIndex]
    }
}


// ******************************* MARK: - Other

extension String {
    
    /// Returns fileName without extension
    var fileName: String {
        guard let lastPathComponent = components(separatedBy: "/").last else { return "" }
        
        var components = lastPathComponent.components(separatedBy: ".")
        if components.count == 1 {
            return lastPathComponent
        } else {
            components.removeLast()
            return components.joined(separator: ".")
        }
    }
}
