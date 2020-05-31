//
//  PieceTests.swift
//  iOS-ChessTests
//
//  Created by Alvin Ling on 6/20/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import XCTest
@testable import Chess

class PieceTests: XCTestCase {
    
    var board: Chessboard!
    let height = 8
    let width = 8
    let moveRules = ChessMoves()
    var moves: [Point] = []
    
    override func setUp() {
        board = Chessboard(width: width, height: height)
        moves = []
    }
    
    func checkMoveCount(at point: Point, with count: Int) {
        moves = moveRules.moves(from: point, on: board)
        XCTAssertEqual(count, moves.count)
    }
    
    func put(pieces: [(PieceType, Point)], color: Color) {
        for (type, point) in pieces {
            board[point] = type * color
        }
    }
    
    func put(pieces: [(PieceType, Color, Point)]) {
        for (type, color, point) in pieces {
            board[point] = type * color
        }
    }
    
    func put(targets: [Point], color: Color) {
        for point in targets {
            board[point] = .pawn * color
        }
    }
    
}

