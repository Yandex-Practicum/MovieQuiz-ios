//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 14.11.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    
    var correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
    
    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct == rhs.correct
    }
    
    static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct > rhs.correct
    }
}
