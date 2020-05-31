//
//  PieceTests.swift
//  iOS-ChessTests
//
//  Created by Alvin Ling on 6/20/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import XCTest
@testable import iOS_Chess

class PieceTests: XCTestCase {
    
    var board: Board!
    let height = 8
    let width = 8
    let moveRules = ChessMoves()
    var moves: [Point] = []
    
    override func setUp() {
        board = Board(width: width, height: height)
        moves = []
    }
    
    func checkMoveCount(at point: Point, with count: Int) {
        moves = moveRules.moves(from: point, on: board)
        XCTAssertEqual(count, moves.count)
    }
    
    func put(pieces: [(PieceType, Point)], color: Color) {
        for (type, point) in pieces {
            board.set(at: point, type, color)
        }
    }
    
    func put(pieces: [(PieceType, Color, Point)]) {
        for (type, color, point) in pieces {
            board.set(at: point, type, color)
        }
    }
    
    func put(targets: [Point], color: Color) {
        for point in targets {
            board.set(at: point, .pawn, color)
        }
    }
    
}

