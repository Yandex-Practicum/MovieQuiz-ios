//
//  BestGameModel.swift
//  MovieQuiz
//
//  Created by Елена Михайлова on 09.04.2023.
//

import Foundation

struct BestGame: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension BestGame: Comparable {
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.correct < rhs.correct
    }
    
    
}
