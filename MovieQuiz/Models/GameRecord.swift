//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 26.11.2023.
//

import Foundation

struct BestGame: Comparable, Codable {
    var correct: Int  // количество правильных ответов
    var total: Int  // количество вопросов квиза
    var date: Date // дата завершения раунда
    
    
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}
