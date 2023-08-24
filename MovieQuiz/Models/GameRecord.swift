//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Виктор Корольков on 20.08.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
