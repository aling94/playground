#!/usr/bin/swift
import Foundation

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

// MARK: - ColorAssets

/// Model class for parsing Palette and Alias Colors from a JSON file and creating their respective
/// JSON files and Swift extension files.
final class ColorAssets: Decodable, Encodable {
    let palette: [Group]
    let aliases: [Group]
    
    /// A list of colors groups, each consisting of a group name and a list of colors with each
    /// color's corrresponding content for its Color Asset Contents.json file.
    lazy var content = (palette: palette.map(AssetContent), aliases: aliases.map(AssetContent))
    
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
    private lazy var maxLen = (name: palette.maxNameLen, alias: aliases.maxNameLen)
    
    /// A mapping of palette references (groupName.colorName) to their respective hex values.
    private lazy var paletteMap: [String : String] = palette.reduce([:]) { (map, group) in
        var map = map
        let name = group.name
        group.colors.forEach { map["\(name).\($0.name)"] = $0.val }
        return map
    }
    
    /// Formats group data to be written as Color Asset Contents.json files.
    private func AssetContent(_ group: Group) -> ColorGen.AssetContent {
        (group.name.capitalized, group.colors.map { color in (color.name, jsonContent(color)) })
    }
    
    /// Constructs the contents for a Color Asset Content.swift file, assuming the String is an RGB
    /// hex String.
    private func jsonContent(_ color: Color) -> String {
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
    
    private func swiftLines(_ input: [Group]) -> String {
        return input.map { group in
            """
              // MARK: - \(group.name.capitalized)
            \(group.colors.map(staticLine).joined(separator: "\n"))
            
            """
        }.joined(separator: "\n")
    }
    
    private func staticLine(_ color: Color) -> String {
        let name = color.name.pad(color.isAlias ? maxLen.alias : maxLen.name)
        return "  static let \(name) = \(assignVal(color))"
    }
    
    /// Returns the Palette color reference if an aliases, otherwise returns the color literal.
    private func assignVal(_ color: Color) -> String {
        let val = color.val
        if color.isAlias { return "Palette.\(val.split(separator: ".").last ?? "")" }
        let (r, g, b) = val.rgb
        let hex = "\(val.hasPrefix("#") ? "" : "#")\(val)"
        return "#colorLiteral(red: \(r), green: \(g), blue: \(b), alpha: 1.0)   ///  \(hex)"
    }
}

// MARK: - Helpers

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
    var rgb: (r: CGFloat, g: CGFloat, b: CGFloat) {
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
        } catch { exitWith(error.localizedDescription) }
    }
}

// MARK: - ColorGen

/// Uses the data parsed by `ColorAssets` to create Color Asset JSON files and Swift UIColor
/// extensions for use in XCode projects.
final class ColorGen {
    typealias AssetContent = (String, [(String, String)])
    
    static let shared = ColorGen()
    
    var assets: ColorAssets?
    let outputPaths: [URL] = [.colors, .aliases, .colorFile]
    
    func run() {
        getInput()
        writeFiles()
        finish()
    }
    
    func deleteFiles() {
        outputPaths.forEach { try? FileManager.default.removeItem(at: $0) }
    }
    
    private func getInput() {
        print("Getting Input")
        let userInput = CommandLine.arguments.count >= 2
        load(from: userInput ? CommandLine.arguments[1] : URL.source.relativePath)
    }

    private func load(from path: String) {
        print("Loading from: \(path)")
        guard let data = FileManager.default.contents(atPath: path)
        else { exitWith("File at path '\(path)' not found") }
        guard let input = try? JSONDecoder().decode(ColorAssets.self, from: data)
        else { exitWith("Input has wrong format") }
        assets = input
    }
    
    private func writeFiles() {
        print("Writing Files")
        guard let assets = assets else { exitWith("Input is missing") }
        deleteFiles()
        createColorSetFile(list: assets.content.palette, parent: .colors)
        createColorSetFile(list: assets.content.aliases, parent: .aliases)
        assets.extensionFile().write("Colors.swift", parent: .root)
    }
    
    private func finish() {
        exitWith("Success", code: EXIT_SUCCESS)
    }
    
    private func createColorSetFile(list: [AssetContent], parent: URL) {
        list.forEach { (groupName, colors) in
            let group = parent.appendingPathComponent(groupName, isDirectory: true)
            colors.forEach { colorName, json in
                let dir = group.appendingPathComponent("\(colorName).colorset", isDirectory: true)
                json.write("Contents.json", parent: dir)
            }
        }
    }
}

func exitWith(_ message: String, code: Int32 = -1) -> Never {
    print(message)
    exit(code)
}

// MARK: - File Paths
extension URL {
    static let root = URL(fileURLWithPath: #file).deletingLastPathComponent()
    static let assets = root.appendingPathComponent("Colors.xcassets", isDirectory: true)
    static let colors = assets.appendingPathComponent("Colors", isDirectory: true)
    static let aliases = assets.appendingPathComponent("Aliases", isDirectory: true)
    static let source = root.appendingPathComponent("ColorSource.json", isDirectory: false)
    static let colorFile = root.appendingPathComponent("Colors.swift", isDirectory: false)
}


// MARK: - Main
ColorGen.shared.run()
