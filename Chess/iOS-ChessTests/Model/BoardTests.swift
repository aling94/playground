//
//  BoardTests.swift
//  iOS-ChessTests
//
//  Created by Alvin Ling on 6/20/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import XCTest
@testable import iOS_Chess

class BoardTests: XCTestCase {
    
    var board: Board!
    let height = 6
    let width = 8
    
    override func setUp() {
        board = Board(width: width, height: height)
    }
    
    
    override func tearDown() {
        board = nil
    }
    
    func forAllSquares(test: (Point) -> Void) {
        for x in 0 ..< width {
            for y in 0 ..< height {
                test((x,y))
            }
        }
    }
    
    func testInit() {
        XCTAssertEqual(width, board.width, "Width should be \(width)")
        XCTAssertEqual(height, board.height, "Height should be \(height)")

    }
    
    func testInBounds() {
        forAllSquares { sqr in
            XCTAssertTrue(board.inBounds(sqr), "Square should be in bounds")
            XCTAssertNotNil(board[sqr], "Square should not be nil")
        }
    }
    
    func testSubscript() {
        let piece = 1
        let point = (0, 0)
        XCTAssertEqual(0, board[point])
        board[point] = piece
        XCTAssertEqual(piece, board[point])
        XCTAssertEqual(piece, board[point.0, point.1])
    }
    
    func testOutOfBounds() {
        let msg = "Square should be out of bounds"
        let invalidX = [-1, width, width + 1]
        let invalidY = [-1, height, height + 1]
        invalidX.forEach { x in
            let p1 = (x, 0)
            let p2 = (x, height - 1)
            XCTAssertFalse(board.inBounds(p1), msg)
            XCTAssertFalse(board.inBounds(p2), msg)
        }

        invalidY.forEach { y in
            let p1 = (0, y)
            let p2 = (width - 1, y)
            XCTAssertFalse(board.inBounds(p1), msg)
            XCTAssertFalse(board.inBounds(p2), msg)
        }
    
    }
    
    
    
}
