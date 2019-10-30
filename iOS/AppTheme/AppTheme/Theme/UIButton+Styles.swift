//
//  UIButton+Styles.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/24/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

/**
 # Usage:
     This extension is used for creating pre-defined button styles that can be used throughout the app.
 
 # Defining a new style:
 - Add a new ButtonStyle enum case to represent the new style
 - Update the switch statement in the attributes(for style:) function
     - Note that the Attribute main initializer has default values for the fields you do not specify
 */

import UIKit

/// A tuple of colors for corresponding UIControl.State values.
typealias StateColors = (normal: UIColor?, disabled: UIColor?, highlighted: UIColor?)

// MARK: - ButtonStyle Cases
extension UIButton {

    enum ButtonStyle {
        case normal
    }
}

// MARK: - Style Attribute Definitions

/// Returns attributes for a given ButtonStyle.
private func attributes(for style: UIButton.ButtonStyle) -> Attributes {
    switch style {
    case .normal:
        return Attributes.solidButton(.orange)
    }
}

// MARK: - UIButton Style
extension UIButton {

    /// Sets the style of the button. For use with custom type UIButtons.
    func setStyle(_ style: ButtonStyle, setCorners: Bool = true) {
        let attrs = attributes(for: style)
        setColors(attrs.color, setBackground)
        setColors(attrs.title, setTitleColor)
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
        if let color = color, color != .clear {
            setBackgroundImage(UIImage(color: color), for: state)
        } else {
            setBackgroundImage(nil, for: state)
        }
    }
    
    /// Helper function for setting color for states
    private func setColors(_ colors: StateColors, _ setter: (UIColor?, UIControl.State) -> Void) {
        setter(colors.normal, .normal)
        setter(colors.disabled, .disabled)
        setter(colors.highlighted, .highlighted)
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
