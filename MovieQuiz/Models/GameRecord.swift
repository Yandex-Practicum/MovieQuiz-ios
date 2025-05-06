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
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    static func <= (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct <= rhs.correct
    }
    static func >= (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct >= rhs.correct
    }
    static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct > rhs.correct
    }
}

