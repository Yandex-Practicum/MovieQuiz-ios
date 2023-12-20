//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 18.12.2023.
//

import UIKit

struct GameRecord: Codable {
    // сколько ответил правильно
    let correct: Int
    // количество вопросов
    let total: Int
    // дата игры
    let date: Date
    
    // метод сразвнивает текущее значение правильных ответов с другой игрой
    func comparisonCorrect(currentGame: GameRecord) -> Bool {
        correct > currentGame.correct
    }
}
