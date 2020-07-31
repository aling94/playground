//
//  UISearchBar+Extension.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/28/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var field: UITextField {
        if #available(iOS 13, *) { return searchTextField }
        return value(forKey: "searchField") as? UITextField ?? UITextField()
    }

    func setFieldColor(_ color: UIColor) {
        field.backgroundColor = color
        if #available(iOS 13, *) { return }
        // iOS 12 and earlier
        guard let bg = field.subviews.first else { return }
        if #available(iOS 11, *) {
            bg.backgroundColor = color
            bg.subviews.forEach { $0.removeFromSuperview() }
        }
        bg.layer.cornerRadius = 10.5
        bg.layer.masksToBounds = true
    }
}
