//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by macOS on 30.09.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (oldValue: GameRecord, newValue: GameRecord) -> Bool {
        return oldValue.correct < newValue.correct
    }
    
    func toString() -> String {
        return "\(correct)/\(total) (\(date.dateTimeString))"
    }
}
