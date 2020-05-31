//
//  ChessMoves.swift
//  Chess
//
//  Created by Alvin Ling on 6/21/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

private let
    verticals:   [Move] = [.up, .down],
    horizontals: [Move] = [.left, .right],
    orthogonals: [Move] = [.up, .down, .left, .right],
    diagonals:   [Move] = [Move.up.left, Move.up.right, Move.down.left, Move.down.right]

struct ChessMoves {

    private typealias Context = (point: Point, board: Chessboard, color: Color)

    func moveFilter(_ point: Point, color: Color, board: Chessboard) -> Bool {
        return board.inBounds(point) && board[point].color != color
    }
    
    func moves(from point: Point, on board: Chessboard) -> [Point] {
        guard board.inBounds(point) else { return [] }
        let moves = generateMoves(from: point, on: board)
        let color = board[point].color
        return moves.filter { point in moveFilter(point, color:color , board: board) }
    }
    
    private func generateMoves(from point: Point, on board: Chessboard) -> [Point] {
        let piece = board[point]
        guard !piece.isEmpty else { return [] }
        let context = (point, board, piece.color)
        switch piece.type {
            
        case .empty:   return []
        case .pawn:    return pawnMoves(context: context)
        case .knight:  return knightMoves(context: context)
        case .bishop:  return bishopMoves(context: context)
        case .rook:    return rookMoves(context: context)
        case .queen:   return queenMoves(context: context)
        case .king:    return kingMoves(context: context)
        }
    }
    
    private func pawnMoves(context: Context) -> [Point] {
        let (point, board, color) = context
        let forward = color.forward
        guard forward != .id else { return [] }
        let front = point + forward
        
        var moves = (point ~> [forward.left, forward.right]).filter { pt in
            guard board.inBounds(pt) else { return false }
            let clr = board[pt].color
            return clr != .blank && clr != color
        }
        if board.inBounds(front) && board[front].isEmpty { moves.append(front) }
        return moves
    }
    
    private func knightMoves(context: Context) -> [Point] {
        var moves: [Move] = []
        for dx in horizontals {
            for dy in verticals {
                moves.append(dx[2] + dy)
                moves.append(dy[2] + dx)
            }
        }
        return context.point ~> moves
    }
    
    private func bishopMoves(context: Context) -> [Point] {
        return movesInLine(context: context, directions: diagonals)
    }
    private func rookMoves(context: Context) -> [Point] {
        return movesInLine(context: context, directions: orthogonals)
    }
    
    private func queenMoves(context: Context) -> [Point] {
        return movesInLine(context: context, directions: orthogonals + diagonals)
    }
    
    private func kingMoves(context: Context) -> [Point] {
        return context.point ~> (orthogonals + diagonals)
    }
    
    private func movesInLine(context: Context,
                             directions: [Move]) -> [Point] {
        
        let (point, board, color) = context
        var moves: [Point] = []
        for dxy in directions {
            var current = point + dxy
            while board.inBounds(current) {
                let clr = board[point].color
                guard clr != color else { break }
                moves.append(current)
                if clr != .blank { break }
                current = point + dxy
            }
        }
        return moves
    }
}

