//
//  File.swift
//  MovieQuiz
//
//  Created by Daud Tsechoev on 06.05.2024.
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

