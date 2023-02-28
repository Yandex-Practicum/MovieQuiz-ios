//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Видич Анна  on 26.2.23..
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    var total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
