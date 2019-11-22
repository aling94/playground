//
//  MoveTests.swift
//  BoardGamesCoreTests
//
//  Created by Alvin Ling on 6/23/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import XCTest
@testable import BoardGamesCore

class MoveTests: XCTestCase {
    
    let up = Move.up
    let down = Move.down
    let left = Move.left
    let right = Move.right
    
    func checkComponents(_ move: Move, _ components: Point) {
        XCTAssertEqual(move.x, components.x)
        XCTAssertEqual(move.y, components.y)
    }
    
    func checkComponents(_ p1: Point, _ p2: Point) {
        XCTAssertEqual(p1.x, p2.x)
        XCTAssertEqual(p1.y, p2.y)
    }
    
    func testEquality() {
        let id = Move(0, 0)
        XCTAssertEqual(id, Move(0, 0))
        XCTAssertNotEqual(id, Move(1, 1))
        XCTAssertNotEqual(id, Move(0, 1))
        XCTAssertNotEqual(id, Move(1, 0))
    }
    
    func testStaticMoves() {
        checkComponents(.id, (0, 0))
        checkComponents(.up, (0, 1))
        checkComponents(.down, (0, -1))
        checkComponents(.left, (-1, 0))
        checkComponents(.right, (1, 0))
    }
    
    func testDirectionMethods() {
        let id = Move(0, 0)
        checkComponents(id.up, (0, 1))
        checkComponents(id.down, (0, -1))
        checkComponents(id.left, (-1, 0))
        checkComponents(id.right, (1, 0))
    }
    

    
    func testContains() {
        let array = [Move(1, 1)]
        XCTAssertTrue(array.contains(Move(1, 1)))
        XCTAssertFalse(array.contains(Move(-3, 0)))
    }
    
    func testMovePlusOperator() {
        let id = Move(0, 0)
        checkComponents(id + .up, (id.x, id.y + 1))
        checkComponents(id + .down, (id.x, id.y - 1))
        checkComponents(id + .left, (id.x - 1, id.y))
        checkComponents(id + .right, (id.x + 1, id.y))
    }
    
    func testPointPlusOperator() {
        let id: Point = (0, 0)
        checkComponents(id + .up, (id.x, id.y + 1))
        checkComponents(id + .down, (id.x, id.y - 1))
        checkComponents(id + .left, (id.x - 1, id.y))
        checkComponents(id + .right, (id.x + 1, id.y))
    }
    
    func testMultOerator() {
        let id = Move(1, 2)
        for scalar in 2...10 {
            checkComponents(id * scalar, (id.x * scalar, id.y * scalar))
            checkComponents(id[scalar], (id.x * scalar, id.y * scalar))
        }
        
    }
}
