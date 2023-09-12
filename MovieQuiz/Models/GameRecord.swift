//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by  Игорь Килеев on 11.09.2023.
//

import Foundation

struct GameRecord: Codable {
    //кол-во правильных овтетов
    let correct: Int
    //кол-во вопросов квиза
    let total: Int
    //дата завершения раунда
    let date: Date
}

extension GameRecord: Comparable {
    
    private var accuracy: Double {
        guard correct == 0 else {
            return 0
        }
        return Double(correct) / Double(total) * 100
    }
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
