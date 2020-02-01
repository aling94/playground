//
//  UIView+Extensions.swift
//  ViewPrototypes
//
//  Created by Alvin Ling on 2/1/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        
        set { layer.borderColor = newValue?.cgColor }
    }
}
