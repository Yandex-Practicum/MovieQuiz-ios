//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Kuimova Olga on 21.04.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func comparisonResults (currentResult: GameRecord, bestResult: GameRecord) -> GameRecord{
        if bestResult.correct < currentResult.correct {
            return (currentResult)
        } else {
            return (bestResult)
        }
    }
}
