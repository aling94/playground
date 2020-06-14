//
//  Paths.swift
//  ColorAssetGen
//
//  Created by Alvin Ling on 6/14/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

extension URL {
    static let root = URL(fileURLWithPath: #file).deletingLastPathComponent()
    static let assets = root.appendingPathComponent("Colors.xcassets", isDirectory: true)
    static let colors = assets.appendingPathComponent("Colors", isDirectory: true)
    static let aliases = assets.appendingPathComponent("Aliases", isDirectory: true)
    static let source = root.appendingPathComponent("ColorSource.json", isDirectory: false)
    static let colorFile = root.appendingPathComponent("Colors.swift", isDirectory: false)
}
