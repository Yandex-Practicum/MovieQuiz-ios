//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by tommy tm on 21.12.2022.
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
