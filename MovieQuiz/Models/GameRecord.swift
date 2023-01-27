//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 12.01.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        let lhsAccuracy = Double(lhs.correct / rhs.correct)
        let rhsAccuracy = Double(lhs.total / rhs.total)
        return lhsAccuracy < rhsAccuracy
    }
}
