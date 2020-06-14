//
//  ColorGen.swift
//  ColorAssetGen
//
//  Created by Alvin Ling on 6/14/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

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
}

private extension ColorGen {
    func getInput() {
        print("Getting Input")
        let userInput = CommandLine.arguments.count >= 2
        load(from: userInput ? CommandLine.arguments[1] : URL.source.relativePath)
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
        createColorSetFile(list: assets.content.palette, parent: .colors)
        createColorSetFile(list: assets.content.aliases, parent: .aliases)
        assets.extensionFile().write(to: .colorFile)
    }
    
    func finish() {
        exitWith("Success", code: EXIT_SUCCESS)
    }
    
    func createColorSetFile(list: [AssetContent], parent: URL) {
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
