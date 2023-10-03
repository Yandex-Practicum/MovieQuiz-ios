//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Кирилл on 01.10.2023.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date?
    func compareGameRecords(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
