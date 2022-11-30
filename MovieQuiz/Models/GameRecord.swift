//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Алексей on 12.12.2022.
//

import Foundation

struct GameRecord: Comparable, Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
    lhs.correct < rhs.correct
    }
} 
