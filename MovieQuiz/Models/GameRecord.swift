//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
   
    //количество правильных ответов
    let correct: Int
    //количество вопросов квиза
    let total: Int
    let date: Date
    
    // метод для сравнения счета на основе правильных ответов
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
