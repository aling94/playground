#!/usr/bin/env xcrun --sdk macosx swift

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

// MARK: - ColorAssets

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
    
    /// Formats group data to be written as Color Asset Contents.json files.
    private func assetContent(_ group: Group) -> ColorGen.AssetContent {
        (group.name.capitalized, group.colors.map { color in (color.name, jsonContent(color)) })
    }
    
    /// Constructs the contents for a Color Asset Content.swift file, assuming the String is an RGB
    /// hex String.
    private func jsonContent(_ color: Color) -> String {
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
    
    private func swiftLines(_ input: [Group]) -> String {
        return input.map { group in
            """
              // MARK: - \(group.name.capitalized)
            \(group.colors.map(staticLine).joined(separator: "\n"))
            
            """
        }.joined(separator: "\n")
    }
    
    private func staticLine(_ color: Color) -> String {
        // Use Palette color reference if an aliases, otherwise use color literal.
        var val: String = "Palette.\(color.ref)"
        if !color.isAlias {
            let (r, g, b, a) = color.rgba
            val = "#colorLiteral(red: \(r), green: \(g), blue: \(b), alpha: \(a ?? 1))  ///  \(color.hex)"
        } else if let a = color.alpha { val.append(".withAlphaComponent(\(a))") }
        return "  static let \(color.name.pad(maxLen)) = \(val)"
    }
}

// MARK: - Helpers

extension CGFloat {
    init(_ number: String) { self.init(Double(number) ?? 1) }
}

extension UInt64 {
    var red:   CGFloat { CGFloat((self & 0xFF0000) >> 16) / 255.0 }
    var green: CGFloat { CGFloat((self & 0x00FF00) >> 8) / 255.0 }
    var blue:  CGFloat { CGFloat(self & 0x0000FF) / 255.0 }
}

extension String {
    
    /// Pad the String up to a length.
    func pad(_ length: Int) -> String {
        count >= length ? self : padding(toLength: length, withPad: " ", startingAt: 0)
    }
    
    func write(to path: URL) {
        do {
            try FileManager.default.createDirectory(
                at: path.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )
            FileManager.default.createFile(
                atPath: path.relativePath,
                contents: data(using: .utf8),
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
        assets.extensionFile().write(to: .colorFile)
    }
    
    private func finish() {
        exitWith("Success", code: EXIT_SUCCESS)
    }
    
    private func createColorSetFile(list: [AssetContent], parent: URL) {
        list.forEach { (groupName, colors) in
            let group = parent.appendingPathComponent(groupName, isDirectory: true)
            colors.forEach { colorName, json in
                let path = group
                    .appendingPathComponent("\(colorName).colorset", isDirectory: true)
                    .appendingPathComponent("Contents.json", isDirectory: false)
                json.write(to: path)
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
    static let root = URL(fileURLWithPath: #file)
        .deletingLastPathComponent() // $SRCROOT/BuildScripts/colorgen/
    static let source = root.appendingPathComponent("ColorSource.json", isDirectory: false)
    
    static let projectRoot = root
        .deletingLastPathComponent() // $SRCROOT/BuildScripts/
        .deletingLastPathComponent() // $SRCROOT/
        .appendingPathComponent("TestBuildPhases", isDirectory: true)
    
    static let assets = projectRoot.appendingPathComponent("Colors.xcassets", isDirectory: true)
    static let colorFile = projectRoot.appendingPathComponent("Colors.swift", isDirectory: false)
    
    static let colors = assets.appendingPathComponent("Colors", isDirectory: true)
    static let aliases = assets.appendingPathComponent("Aliases", isDirectory: true)
}


// MARK: - Main
ColorGen.shared.run()
