//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 05.12.2022.
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
