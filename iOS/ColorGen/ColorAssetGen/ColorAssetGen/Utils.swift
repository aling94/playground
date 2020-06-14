//
//  Utils.swift
//  ColorAssetGen
//
//  Created by Alvin Ling on 6/14/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

func exitWith(_ message: String, code: Int32 = -1) -> Never {
    print(message)
    exit(code)
}

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
