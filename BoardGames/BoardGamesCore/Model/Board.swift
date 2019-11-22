//
//  Board.swift
//  BoardGames
//
//  Created by Alvin Ling on 6/21/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

protocol Board {
    
    associatedtype BoardPiece
    
    var width: Int { get }
    var height: Int { get }
    
    subscript (x: Int, y: Int) -> BoardPiece { get set }
    
    func inBounds(_ point: Point) -> Bool

    func remove(on point: Point)
}

extension Board {
    
    func inBounds(_ point: Point) -> Bool {
        return -1 < point.x && point.x < width && -1 < point.y && point.y < height
    }
    
}
