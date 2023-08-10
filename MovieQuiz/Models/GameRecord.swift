//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Ivan on 16.07.2023.
//
import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
