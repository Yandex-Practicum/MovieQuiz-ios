//
//  GameRecorder.swift
//  MovieQuiz
//
//  Created by Слава Шестаков on 06.11.2022.
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
}
