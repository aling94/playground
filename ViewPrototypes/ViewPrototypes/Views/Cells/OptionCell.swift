//
//  OptionCell.swift
//  ViewPrototypes
//
//  Created by Alvin Ling on 2/2/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Private setup and helpers
private extension OptionCell {
    
    func commonInit() {
        selectionStyle = .none
    }
}
