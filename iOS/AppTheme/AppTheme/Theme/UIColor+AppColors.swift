//
//  UIColor+AppColors.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/18/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

private func / (lhs: Int, rhs: CGFloat) -> CGFloat { return CGFloat(lhs) / rhs }
private func * (lhs: CGFloat, rhs: Double) -> CGFloat { return lhs * CGFloat(rhs) }

private extension Int {
    var red: Int { return (self >> 16) & 0xFF }
    var green: Int { return (self >> 8) & 0xFF }
    var blue: Int { return self & 0xFF }
}

extension UIColor {
    
    /// Create a color from a hex input (0x123456)
    convenience init(_ rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: rgb.red / 255.0,
            green: rgb.green / 255.0,
            blue: rgb.blue / 255.0,
            alpha: alpha
        )
    }
    
    /// Scales the brightness by a factor
    func adjustBrightness(_ factor: Double) -> UIColor {
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }
    
    /// Darkens the color by a factor
    func darken(_ percent: Double) -> UIColor {
        return adjustBrightness(1 - percent)
    }
    
    /// Brightens the color by a factor
    func lighten(_ percent: Double) -> UIColor {
        return adjustBrightness(1 + percent)
    }
    
}
