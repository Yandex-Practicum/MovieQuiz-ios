//
//  RecordGameModel.swift
//  MovieQuiz
//
//  Created by Ilya Shirokov on 29.12.2023.
//

import Foundation

struct GameRecord: Codable {
    //количество правильных ответов
    let correct: Int
    //количество вопросов квиза
    let total: Int
    //дата завершения раунда
    let date: Date
    
    func comparisonResults(_ newGame: GameRecord) -> Bool {
        correct > newGame.correct
    }
}
