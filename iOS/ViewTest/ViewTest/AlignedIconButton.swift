//
//  AlignedIconButton.swift
//  ViewTest
//
//  Created by Alvin Ling on 7/7/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class AlignedIconButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.2
        layer.cornerRadius = 4
        titleLabel?.backgroundColor = .orange
        imageView?.backgroundColor = .purple
        
        
    }
}
