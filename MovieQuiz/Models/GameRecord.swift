//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 26.11.2023.
//

import Foundation

struct GameRecord: Comparable, Codable {
    var correct: Int  // количество правильных ответов
    var total: Int  // количество вопросов квиза
    var date: Date // дата завершения раунда
    
    
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}
