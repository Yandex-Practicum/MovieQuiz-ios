//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 14.12.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int // общее данных правильных ответов
    let total: Int // общее количество вопросов
    let date: Date // дата прохождения
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}


