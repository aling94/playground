//
//  UIButton+Styles.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/24/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

/**
# Defining a new style:
- Add a new ButtonStyle enum case to represent the new style
- Update the switch statement in the attributes(for style:) function
    - Note that the Attribute main initializer has default values for the fields you do not specify
 */

import UIKit

/// A tupe of colors for corresponding UIControl.State values.
typealias StateColors = (normal: UIColor?, disabled: UIColor?, highlighted: UIColor?)

extension UIButton {
    
    // MARK: - ButtonStyle Cases
    enum ButtonStyle {
        case normal
    }
    
    // MARK: - Style Attribute Definitions
    
    /// Returns attributes for a given ButtonStyle.
    private class func attributes(for style: ButtonStyle) -> Attributes {
        switch style {
        default:
            return Attributes.solidButton(.orange)
        }
        
    }
    
    /// Sets the style of the button. For use with custom type UIButtons.
    func setStyle(_ style: ButtonStyle, setCorners: Bool = true) {
        let attrs = UIButton.attributes(for: style)
        setBackgrounds(attrs.color)
        setTitleColors(attrs.title)
        backgroundColor = attrs.background
        if setCorners {
            clipsToBounds = attrs.cornerRadius > 0
            layer.cornerRadius = attrs.cornerRadius
        }
        layer.borderWidth = attrs.border.width
        layer.borderColor = attrs.border.color?.cgColor
    }
    
    /// Sets the background to a solid color for the given state.
    func setBackground(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            setBackgroundImage(UIImage(color: color), for: state)
        } else {
            setBackgroundImage(nil, for: state)
        }
    }
    
    /// Sets the background colors according to the given style.
    func setBackgrounds(_ colors: StateColors) {
        setBackground(colors.normal, for: .normal)
        setBackground(colors.disabled, for: .disabled)
        setBackground(colors.highlighted, for: .highlighted)
    }
    
    /// Sets the title colors according to the given style.
    func setTitleColors(_ colors: StateColors) {
        setTitleColor(colors.normal, for: .normal)
        setTitleColor(colors.disabled, for: .disabled)
        setTitleColor(colors.highlighted, for: .highlighted)
    }
}

// MARK: - ButtonStyle Attributes

/// Struct containing attributes that corresponding to a ButtonStyle
private struct Attributes {
    /// Button background color for corresponding states
    let color: StateColors
    /// Title color for corresponding states
    let title: StateColors
    /// Underlying background color
    let background: UIColor?
    /// Button corner radius
    let cornerRadius: CGFloat
    /// Border color and width
    let border: (color: UIColor?, width: CGFloat)
    
    /**
     Main Attributes struct initializer. All fields have default values so feel free to
     pick and choose which to set.
     
     - Parameter normal: Background color for UIControl.State normal.
     - Parameter disabled: Background color for UIControl.State disabled.
     - Parameter highlighted: Background color for UIControl.State highlighted.
     - Parameter titleNormal: Title color for UIControl.State normal.
     - Parameter titleDisabled: Title color for UIControl.State disabled.
     - Parameter titleHighlighted: Title color for UIControl.State highlighted.
     - Parameter background: Underlying background color.
     - Parameter cornerRadius: Button corner radius.
     - Parameter borderColor: Border color.
     - Parameter borderWidth: Border width.
     */
    init(
        normal: UIColor? = nil,
        disabled: UIColor? = nil,
        highlighted: UIColor? = nil,
        titleNormal: UIColor? = .white,
        titleDisabled: UIColor? = nil,
        titleHighlighted: UIColor? = nil,
        background: UIColor? = nil,
        cornerRadius: CGFloat = 5,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0
    ) {
        self.color = (normal, disabled ?? normal?.withAlphaComponent(0.4), highlighted)
        self.title = (normal, titleDisabled ?? titleNormal?.withAlphaComponent(0.4), titleHighlighted)
        self.background = background
        self.cornerRadius = cornerRadius
        self.border = (borderColor, borderWidth)
    }
    
    /// Creates attributes for a solid colored button based on the given base color
    static func solidButton(_ color: UIColor) -> Attributes {
        return Attributes(
            normal: color,
            disabled: color.withAlphaComponent(0.75),
            highlighted: color.darken(0.3)
        )
    }
}
