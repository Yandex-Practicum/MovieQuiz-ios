//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 23.08.2023.
//

import Foundation

/// Параметры игры
/// - Parameters:
///     - correct: количество верных ответов за квиз
/// - total: общее количество вопрос
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
