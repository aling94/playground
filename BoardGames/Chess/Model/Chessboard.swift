//
//  Chessboard.swift
//  Chess
//
//  Created by Alvin Ling on 6/21/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

final class Chessboard: Board {

    typealias BoardPiece = Piece
    
    private var pieces: [[Piece]]
    
    var width: Int { return pieces.count }
    var height: Int { return pieces.first?.count ?? 0 }
    
    init(width: Int = 8, height: Int = 8) {
        precondition(width > 0 && height > 0)
        pieces = Array(repeating: Array(repeating: 0, count: height), count: width)
    }
    
    func setup() {
        let layout: [(Piece, [Point])] = [
            (1, [])
        ]
    }
    
    func setup(pieceLayout: [(Piece, [Point])]) {
        for (piece, points) in pieceLayout {
            for point in points {
                pieces[point.x][point.y] = piece
            }
        }
    }
    
    func clear() {
        pieces = Array(repeating: Array(repeating: 0, count: height), count: width)
    }
    
    subscript(point: Point) -> Piece {
        get { return pieces[point.x][point.y] }
        set(piece) {
            guard inBounds(point), piece.type != .empty else { return }
            pieces[point.x][point.y] = piece
        }
    }
    
    subscript(x: Int, y: Int) -> Piece {
        get { return pieces[x][y] }
        set { self[(x, y)] = newValue }
    }
    
     func remove(on point: Point) {
        self[point] = .empty * .blank
    }
    
    func move(from start: Point, to dest: Point) {
        self[dest] = self[start]
    }
}
