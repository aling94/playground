//
//  PawnTests.swift
//  iOS-ChessTests
//
//  Created by Alvin Ling on 6/20/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import XCTest
@testable import iOS_Chess

final class PawnTests: PieceTests {
    
    let p1 = (2, 0)
    let p2 = (2, 0) + .up
    
    override func setUp() {
        super.setUp()
        board.set(at: p1, .pawn, .white)
    }
    
    func testPawnMoves() {
        checkMoveCount(at: p1, with: 1)
        XCTAssertTrue(moves.first! == (p1 + .up))
    }
    
    func testPawnMovesBlocked() {
        
        board.set(at: p2, .pawn, .white)
        checkMoveCount(at: p1, with: 0)
        board.set(at: p2, .pawn, .black)
        moves = moveRules.moves(from: p1, on: board)
        checkMoveCount(at: p1, with: 0)
    }
    
    func testPawnMovesCapture() {
        put(targets: [p2, p2 + .left, p2 + .right], color: .white)
        checkMoveCount(at: p1, with: 0)
        
        board.set(at: p2 + .left, .pawn, .black)
        checkMoveCount(at: p1, with: 1)
        board.set(at: p2 + .right, .pawn, .black)
        checkMoveCount(at: p1, with: 2)
    }
    
}

