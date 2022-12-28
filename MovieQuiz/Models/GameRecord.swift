//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 12.12.2022.
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
