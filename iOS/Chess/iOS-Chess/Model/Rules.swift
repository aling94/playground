//
//  Rules.swift
//  iOS-Chess
//
//  Created by Alvin Ling on 6/20/19.
//  Copyright © 2019 iOSDev. All rights reserved.
//

import Foundation

enum State {
    case stalement
    case playing
    case ended
}

protocol Rules {
    func filterMoves(from point: Point, on board: Board, moves: [Point]) -> [Point]
    
    
    var winner: Color { get }
    
    var state: State { get }
}


