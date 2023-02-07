//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Иван Иванов on 12.01.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return Double(lhs.correct) <= Double(rhs.correct)
    }
}
