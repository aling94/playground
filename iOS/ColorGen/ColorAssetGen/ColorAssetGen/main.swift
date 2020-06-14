#!/usr/bin/swift
import Foundation

/// ================================================================================================
    // MARK: - Type Defs
/// ================================================================================================

typealias RGB = (r: CGFloat, g: CGFloat, b: CGFloat)

// MARK: - Color

/// Color = [colorName, hexString]
typealias Color = [String]
/// extension Color
extension Array where Element == String {
    var name: String { first ?? "" }
    var val: String { last ?? "" }
    var isAlias: Bool { val.contains(".") }
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


/// ================================================================================================
    // MARK: - ColorAssets
/// ================================================================================================

/// Model class for parsing Palette and Alias Colors from a JSON file and creating their respective
/// JSON files and Swift extension files.
final class ColorAssets: Decodable, Encodable {
    let palette: [Group]
    let aliases: [Group]
    
    /// A mapping of palette references (groupName.colorName) to their respective hex values.
    private lazy var paletteMap: [String : String] = palette.reduce([:]) { (map, group) in
        var map = map
        let name = group.name
        group.colors.forEach { map["\(name).\($0.name)"] = $0.val }
        return map
    }
    
    /// The length of the longest palette color name. Used for padding the Swift extension file.
    private lazy var maxNameLen = palette.maxNameLen
    
    /// The length of the longest alias color name. Used for padding the Swift extension file.
    private lazy var maxAliasLen = aliases.maxNameLen
    
    /// A list of palette groups, each consisting of a group name and a list of colors with each
    /// color's corrresponding content for its Color Asset JSON file.
    lazy var paletteAssets = palette.map { ($0.name.capitalized, $0.colors.map(asset)) }
    
    /// A list of alias groups, each consisting of a group name and a list of colors with each
    /// color's corrresponding content for its Color Asset JSON file.
    lazy var aliasAssets = aliases.map { ($0.name.capitalized, $0.colors.map(asset)) }
    
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
}

private extension ColorAssets {
    
    func asset(_ color: Color) -> (String, String) { (color.name, jsonContent(color)) }
    
    /// Constructs the contents for a Color Asset Content.swift file, assuming the String is an RGB
    /// hex String.
    func jsonContent(_ color: Color) -> String {
       let (r, g, b) = (paletteMap[color.val] ?? color.val).rgb
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
                 "alpha": "1.0"
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
        let name = color.name.pad(color.isAlias ? maxAliasLen : maxNameLen)
        return "  static let \(name) = \(assignVal(color))"
    }
    
    /// Returns the Palette color reference if an aliases, otherwise returns the color literal.
    func assignVal(_ color: Color) -> String {
        let val = color.val
        if color.isAlias { return "Palette.\(val.split(separator: ".").last ?? "")" }
        let (r, g, b) = val.rgb
        let hex = "\(val.hasPrefix("#") ? "" : "#")\(val)"
        return "#colorLiteral(red: \(r), green: \(g), blue: \(b), alpha: 1.0)   ///  \(hex)"
    }
}


/// ================================================================================================
    // MARK: - Helpers
/// ================================================================================================

extension UInt64 {
    var red:   CGFloat { CGFloat((self & 0xFF0000) >> 16) / 255.0 }
    var green: CGFloat { CGFloat((self & 0x00FF00) >> 8) / 255.0 }
    var blue:  CGFloat { CGFloat(self & 0x0000FF) / 255.0 }
}

extension String {
    
    /// Pad the String up to a length.
    func pad(_ length: Int) -> String {
        return self.count >= length ?
            self :
            self.padding(toLength: length, withPad: " ", startingAt: 0)
    }
    
    /// Returns an RGB tuple assuming the String is an RGB hex String.
    var rgb: RGB {
        let cString = self
            .trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            .replacingOccurrences(of: "^#+", with: "", options: .regularExpression)
        guard cString.count == 6 else { return (0, 0, 0) }
        
        var hex: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&hex)
        return (hex.red, hex.green, hex.blue)
    }
    
    func write(_ filename: String, parent: URL) {
        let dir = parent.relativePath
        do {
            try FileManager.default.createDirectory(
                atPath: dir, withIntermediateDirectories: true, attributes: nil
            )
            FileManager.default.createFile(
                atPath: "\(dir)/\(filename)",
                contents: self.data(using: .utf8),
                attributes: nil
            )
        } catch {
            print(error.localizedDescription)
            exit(-1)
        }
    }
}


/// ================================================================================================
    // MARK: - ColorGen
/// ================================================================================================

/// Uses the data parsed by `ColorAssets` to create Color Asset JSON files and Swift UIColor
/// extensions for use in XCode projects.
final class ColorGen {
    typealias AssetGroup = (String, [(String, String)])
    
    static let shared = ColorGen()
    
    var assets: ColorAssets?
    let outputPaths: [URL] = [.colors, .aliases, .extFile]
    
    func run() {
        getInput()
        writeFiles()
        finish()
    }
    
    func deleteFiles() {
        outputPaths.forEach { try? FileManager.default.removeItem(at: $0) }
    }
}

private extension ColorGen {
    func getInput() {
        print("Getting Input")
        let userInput = CommandLine.arguments.count >= 2
        load(from: userInput ? CommandLine.arguments[1] : URL.defSrc.relativePath)
    }

    func load(from path: String) {
        print("Loading from: \(path)")
        guard let data = FileManager.default.contents(atPath: path)
        else { exitWith("File at path '\(path)' not found") }
        guard let input = try? JSONDecoder().decode(ColorAssets.self, from: data)
        else { exitWith("Input has wrong format") }
        assets = input
    }
    
    func writeFiles() {
        print("Writing Files")
        guard let assets = assets else { exitWith("Input is missing") }
        deleteFiles()
        createColorSetFile(list: assets.paletteAssets, parent: .colors)
        createColorSetFile(list: assets.aliasAssets, parent: .aliases)
        assets.extensionFile().write("Colors.swift", parent: .root)
    }
    
    func finish() {
        print("Success")
        assets = nil
        exit(EXIT_SUCCESS)
    }
    
    func createColorSetFile(list: [AssetGroup], parent: URL) {
        list.forEach { (groupName, colors) in
            let group = parent.appendingPathComponent(groupName, isDirectory: true)
            colors.forEach { colorName, json in
                let dir = group.appendingPathComponent("\(colorName).colorset", isDirectory: true)
                json.write("Contents.json", parent: dir)
            }
        }
    }
    
    func exitWith(_ message: String ) -> Never {
        print(message)
        exit(1)
    }
}

// MARK: - File Paths
extension URL {
    static let root = URL(fileURLWithPath: #file).deletingLastPathComponent()
    static let assets = root.appendingPathComponent("Colors.xcassets", isDirectory: true)
    static let colors = assets.appendingPathComponent("Colors", isDirectory: true)
    static let aliases = assets.appendingPathComponent("Aliases", isDirectory: true)
    static let defSrc = root.appendingPathComponent("ColorSource.json", isDirectory: false)
    static let extFile = root.appendingPathComponent("Colors.swift", isDirectory: false)
}


/// ================================================================================================
    // MARK: - Main
/// ================================================================================================


ColorGen.shared.run()
