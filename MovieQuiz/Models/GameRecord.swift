//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 20.04.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct == rhs.correct
    }
    
    let correct: Int
    let total: Int
    let date: String
} 
