//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 08.03.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThen(_ another: GameRecord) -> Bool {
        return correct > another.correct
    }
}
