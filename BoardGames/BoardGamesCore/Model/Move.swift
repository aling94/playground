//
//  Move.swift
//  BoardGamesCore
//
//  Created by Alvin Ling on 6/21/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

typealias Point = (x: Int, y: Int)

func + <T: Numeric> (lhs:(T, T), rhs:(T, T)) -> (T, T) {
    return (lhs.0 + rhs.0, lhs.1 + rhs.1)
}

func == <T:Equatable> (lhs: (T, T),rhs :(T, T)) -> Bool {
    return (lhs.0 == rhs.0) && (lhs.1 == rhs.1)
}

func ~> (lhs: Point, rhs: [Move]) -> [Point] {
    return rhs.map({ lhs + $0 })
}

struct Move: Equatable {

    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    static let up    = Move(0, 1)
    static let left  = Move(-1, 0)
    static let right = Move(1, 0)
    static let down  = Move(0, -1)
    
    static let id    = Move(0, 0)
    
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func != (lhs: Move, rhs: Move) -> Bool {
        return !(lhs == rhs)
    }
    
    static func + (lhs: Move, rhs: Move) -> Move {
        return Move(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func + (lhs: Point, rhs: Move) -> Point {
        return (lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func + (lhs: Move, rhs: Point) -> Point {
        return rhs + lhs
    }
    
    static func * (lhs: Move, rhs: Int) -> Move {
        return Move(lhs.x * rhs, lhs.y * rhs)
    }
    
    static func * (lhs: Move, rhs: CountableRange<Int>) -> [Move] {
        return rhs.map { lhs * $0 }
    }
    
    subscript (scalar: Int) -> Move {
        return self * scalar
    }
    
    var left:  Move { return self + .left }
    var right: Move { return self + .right }
    var up:    Move { return self + .up }
    var down:  Move { return self + .down }
}
