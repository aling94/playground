//
//  Color.swift
//  Chess
//
//  Created by Alvin Ling on 6/21/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

enum Color: Int {
    case blank  = 0
    case white = 1
    case black = -1
    
    /**
     * Returns the [Move](x-source-tag://Move) corresponding to a forward movement for this color.
     */
    var forward: Move {
        switch self {
        case .blank: return .id
        case .white: return .up
        case .black: return .down
        }
    }
}
