//
//  CustomView.swift
//  ViewTest
//
//  Created by Alvin Ling on 5/27/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class CustomView: UIView {

    @IBOutlet var stackView: UIStackView!
    
    static func fromNib() -> Self {
        return UINib(nibName: "\(self)", bundle: nil)
        .instantiate(withOwner: self, options: nil).first as! Self
    }
}
