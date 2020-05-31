//
//  Piece.swift
//  Chess
//
//  Created by Alvin Ling on 6/21/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

typealias Piece = Int

extension Piece {
    
    var isEmpty: Bool { return self == 0 }
    
    var color: Color {
        guard !isEmpty else { return .blank }
        return self > 0 ? .white : .black
    }
    
    var type: PieceType {
        return PieceType.mapping[abs(self)] ?? .empty
    }
}


enum PieceType: Int, CaseIterable {
    case empty   = 0
    case pawn    = 1
    case knight  = 2
    case bishop  = 3
    case rook    = 4
    case queen   = 5
    case king    = 6
    
    static let mapping: [Int : PieceType] = {
        return PieceType.allCases.reduce([:], { (dict, type) -> [Int : PieceType] in
            var dict = dict
            dict[type.rawValue] = type
            return dict
        })
    }()
    
    static func * (lhs: PieceType, rhs: Color) -> Piece {
        return lhs.rawValue * rhs.rawValue
    }
    
    static func * (lhs: Color, rhs: PieceType) -> Piece {
        return lhs.rawValue * rhs.rawValue
    }
}

