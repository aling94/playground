//
//  Board.swift
//  iOS-Chess
//
//  Created by Alvin Ling on 6/19/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

struct Board {
    
    private var pieces: [[Piece]]
    
    var width: Int { return pieces.count }
    var height: Int { return pieces.first?.count ?? 0 }
    
    init(width: Int, height: Int) {
        precondition(width > 0 && height > 0)
        pieces = Array(repeating: Array(repeating: 0, count: height), count: width)
    }
    
    
    func inBounds(_ point: Point) -> Bool {
        
        return -1 < point.x && point.x < width &&
               -1 < point.y && point.y < height
    }
    
    subscript(point: Point) -> Piece {
        get {
            return pieces[point.x][point.y]
        }
        set {
            guard inBounds(point) else { return }
            pieces[point.x][point.y] = newValue
        }
    }
    
    subscript(x: Int, y: Int) -> Piece {
        get {
            return pieces[x][y]
        }
        set {
            guard inBounds((x, y)) else { return }
            pieces[x][y] = newValue
        }
    }
    
    mutating func set(at point: Point, _ piece: PieceType, _ color: Color) {
        self[point] = piece.rawValue * color.rawValue
    }
    
    mutating func move(from start: Point, to dest: Point) {
        self[dest] = self[start]
    }
}

