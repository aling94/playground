//
//  ColorAssets.swift
//  ColorAssetGen
//
//  Created by Alvin Ling on 6/14/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

/// Model class for parsing Palette and Alias Colors from a JSON file and creating their respective
/// JSON files and Swift extension files.
final class ColorAssets: Decodable, Encodable {
    let palette: [Group]
    let aliases: [Group]
    
    /// A list of colors groups, each consisting of a group name and a list of colors with each
    /// color's corrresponding content for its Color Asset Contents.json file.
    lazy var content = (palette: palette.map(assetContent), aliases: aliases.map(assetContent))
    
    /// Content for the Swift extension file.
    func extensionFile() -> String {
        """
        import UIKit
        
        // MARK: - Palette Colors
        private enum Palette {
        
        \(swiftLines(palette))
        }
        
        // MARK: - Color Aliases
        @objc extension UIColor {
        
        \(swiftLines(aliases))
        }
        """
    }
    
    /// The length of the longest color name/alias. Used for padding the Swift extension file.
    private lazy var maxLen = max(palette.maxNameLen, aliases.maxNameLen)
    
    /// A mapping of palette references (groupName.colorName) to their respective hex values.
    private lazy var paletteMap: [String : Color] = palette.reduce([:]) { (map, group) in
        var map = map
        let name = group.name
        group.colors.forEach { map["\(name).\($0.name)"] = $0 }
        return map
    }
}

private extension ColorAssets {
    
    /// Formats group data to be written as Color Asset Contents.json files.
    func assetContent(_ group: Group) -> ColorGen.AssetContent {
        (group.name.capitalized, group.colors.map { color in (color.name, jsonContent(color)) })
    }
    
    /// Constructs the contents for a Color Asset Content.swift file, assuming the String is an RGB
    /// hex String.
    func jsonContent(_ color: Color) -> String {
        let (r, g, b, a) = (paletteMap[color.val] ?? color).rgba
        let alpha = color.alpha ?? (a ?? 1)
        return """
        {
          "info": { "version": 1, "author": "xcode" },
          "colors": [
            {
              "idiom": "universal",
              "color": {
                "color-space": "srgb",
                "components": {
                  "red": "\(r)",
                  "green": "\(g)",
                  "blue": "\(b)",
                  "alpha": "\(alpha)"
                }
              }
            }
          ]
        }
        """
    }
    
    func swiftLines(_ input: [Group]) -> String {
        return input.map { group in
            """
              // MARK: - \(group.name.capitalized)
            \(group.colors.map(staticLine).joined(separator: "\n"))
            
            """
        }.joined(separator: "\n")
    }
    
    func staticLine(_ color: Color) -> String {
        // Use Palette color reference if an aliases, otherwise use color literal.
        var val: String = "Palette.\(color.ref)"
        if !color.isAlias {
            let (r, g, b, a) = color.rgba
            val = "#colorLiteral(red: \(r), green: \(g), blue: \(b), alpha: \(a ?? 1))  ///  \(color.hex)"
        } else if let a = color.alpha { val.append(".withAlphaComponent(\(a))") }
        return "  static let \(color.name.pad(maxLen)) = \(val)"
    }
}
