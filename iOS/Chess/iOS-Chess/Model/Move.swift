//
//  Move.swift
//  iOS-Chess
//
//  Created by Alvin Ling on 6/19/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

typealias Point = (x: Int, y: Int)

func + <T: Numeric> (lhs:(T, T), rhs:(T, T)) -> (T, T) {
    return (lhs.0 + rhs.0, lhs.1 + rhs.1)
}

func == <T:Equatable> (tuple1:(T,T),tuple2:(T,T)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}

func ~> (lhs: Point, rhs: [Move]) -> [Point] {
    return rhs.map({ lhs + $0 })
}

enum Move {
    case up
    case down
    case left
    case right
    
    case upleft
    case upright
    case downleft
    case downright
    
    case none

    static func * (lhs: Move, rhs: Int) -> Point {
        let point = lhs.value
        return (x: point.x * rhs, y: point.y * rhs)
    }
    
    static func + (lhs: Move, rhs: Point) -> Point {
        return lhs.value + rhs
    }
    
    static func + (lhs: Point, rhs: Move) -> Point {
        return lhs + rhs.value
    }
    
    static func + (lhs: Move, rhs: Move) -> Point {
        return lhs.value + rhs.value
    }
    
    subscript (scalar: Int) -> Point {
        return self * scalar
    }

    var value: Point {
        switch self {
        case .up:        return (0, 1)
        case .left:      return (-1, 0)
        case .right:     return (1, 0)
        case .down:      return (0, -1)
            
        case .upleft:    return (-1, 1)
        case .upright:   return (1, 1)
        case .downleft:  return (1, -1)
        case .downright: return (1, -1)
        case .none:      return (0, 0)
        }
    }
}

protocol MovePolicy {
    func moves(from point: Point, on board: Board) -> [Point]
}

struct ChessMoves: MovePolicy {
    
    func forwardDirection(for color: Color) -> Move {
        switch color {
        case .none: return .none
        case .white: return .up
        case .black: return .down
        }
    }
    
    func moveFilter(_ point: Point, color: Color, board: Board) -> Bool {
        return board.inBounds(point) && board[point].color != color
    }
    
    func moves(from point: Point, on board: Board) -> [Point] {
        let moves = generateMoves(from: point, on: board)
        let color = board[point].color
        return moves.filter { point in moveFilter(point, color:color , board: board) }
    }
    
    func generateMoves(from point: Point, on board: Board) -> [Point] {
        let piece = board[point]
        guard !piece.isEmpty else { return [] }
        let color = piece.color
        switch piece.type {
            
        case .none:   return []
        case .pawn:   return pawnMoves(from: point, on: board, color: color)
        case .knight: return knightMoves(from: point)
        case .bishop: return bishopMoves(from: point, on: board, color: color)
        case .rook:   return rookMoves(from: point, on: board, color: color)
        case .queen:  return queenMoves(from: point, on: board, color: color)
        case .king:   return kingMoves(from: point)
        }
    }
    
    private func pawnMoves(from point: Point, on board: Board, color: Color) -> [Point] {
        let forward = forwardDirection(for: color)
        guard forward != .none else { return [] }
        let front = point + forward
        
        var moves = [front + .left, front + .right].filter { pt in
            guard board.inBounds(pt) else { return false }
            let clr = board[pt].color
            return clr != .none && clr != color
        }
        if board.inBounds(front) && board[front].isEmpty { moves.append(front) }
        return moves
    }
    
    private func knightMoves(from point: Point) -> [Point] {
        var moves: [Point] = []
        for dx: Move in [.left, .right] {
            for dy: Move in [.up, .down] {
                moves.append(point + dx[2] + dy)
                moves.append(point + dy[2] + dx)
            }
        }
        return moves
    }
    
    private func bishopMoves(from point: Point, on board: Board, color: Color) -> [Point] {
        return movesInLine(from: point, on: board, color: color,
                           directions: [.upleft, .upright, .downleft, .downright])
    }
    private func rookMoves(from point: Point, on board: Board, color: Color) -> [Point] {
        return movesInLine(from: point, on: board, color: color,
                           directions: [.up, .left, .down, .right])
    }
    
    private func queenMoves(from point: Point, on board: Board, color: Color) -> [Point] {
        return movesInLine(from: point, on: board, color: color,
                           directions: [.up, .left, .down, .right,
                                        .upleft, .upright, .downleft, .downright])
    }
    
    private func kingMoves(from point: Point) -> [Point] {
        let dirs: [Move] = [.up, .left, .down, .right, .upleft, .upright, .downleft, .downright]
        return dirs.map { dir in
            point + dir
        }
    }
    
    private func movesInLine(from point: Point, on board: Board, color: Color,
                             directions: [Move]) -> [Point] {
        
        var moves: [Point] = []
        for dxy: Move in directions {
            var current = point + dxy
            while board.inBounds(current) {
                let clr = board[point].color
                guard clr != color else { break }
                moves.append(current)
                if clr != .none { break }
                current = point + dxy
            }
        }
        return moves
    }
}
