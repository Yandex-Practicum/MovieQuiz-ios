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
        if lhs.total == 0 {
            return true
        }
        return lhs.correct < rhs.correct && lhs.total < rhs.total
        
    }
}
