//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Marina Kolbina on 17/11/2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    static func <= (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct <= rhs.correct
    }
    static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct > rhs.correct
    }
    static func >= (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct >= rhs.correct
    }
}
