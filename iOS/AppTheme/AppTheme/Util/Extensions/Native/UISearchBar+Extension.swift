//
//  UISearchBar+Extension.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/28/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    dynamic var textField: UITextField? {
        return subviews.map { $0.subviews.first(where: { $0 is UITextInputTraits }) as? UITextField }
            .compactMap { $0 }
            .first
    }
    
    dynamic var fieldColor: UIColor? {
        get { return textField?.backgroundColor }
        set { textField?.backgroundColor = newValue }
    }
}
