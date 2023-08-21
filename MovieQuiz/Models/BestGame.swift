//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Nina Zharkova on 21.08.2023.
//

import Foundation

struct BestGame: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension BestGame: Comparable {
    
    private var accuracy: Double {
        guard total != 0 else {
         return 0
        }
        return Double(correct / total)
    }
    
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.correct < rhs.correct
    }
}
