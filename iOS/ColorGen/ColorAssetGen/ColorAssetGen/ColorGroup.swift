//
//  ColorGroup.swift
//  ColorAssetGen
//
//  Created by Alvin Ling on 6/14/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

// MARK: - Color

/// Color = [colorName, hexString]
typealias Color = [String]

/// extension Color
extension Array where Element == String {
    var name: String { first ?? "" }
    var val: String { count > 1 ? self[1] : "" }
    var alpha: CGFloat? { count > 2 ? CGFloat(self[2]) : nil }
    var isAlias: Bool { val.contains(".") }
    var ref: String { "\(val.split(separator: ".").last ?? "")" }
    var hex: String { val.hasPrefix("#") ? val : "#" + val }
    
    var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat?) {
        let cString = val.uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "^#+", with: "", options: .regularExpression)
        guard cString.count == 6 else { return (0, 0, 0, 1) }
        
        var hex: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&hex)
        return (hex.red, hex.green, hex.blue, alpha)
    }
}

// MARK: - Group

/// Group = { groupName : [[colorName, hexString], ...] }
typealias Group = [String : [Color]]

/// extension Group
extension Dictionary where Key == String, Value == [Color] {
    var name: String { keys.first ?? "" }
    var colors: [Color] { self[name] ?? [] }
}

/// extension [Group]
extension Array where Element == Group { // extension [Group]
    var maxNameLen: Int { flatMap { $0.colors.map { $0.name.count } }.max(by: <) ?? 0 }
}
