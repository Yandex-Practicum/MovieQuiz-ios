//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 18.12.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
    func toString() -> String {
        return "\(correct)/\(total) (\(date.dateTimeString)"
    }
}
