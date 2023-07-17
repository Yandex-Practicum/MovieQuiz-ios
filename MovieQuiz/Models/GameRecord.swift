//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 13.07.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool{
        return lhs.correct < rhs.correct
    }
}
