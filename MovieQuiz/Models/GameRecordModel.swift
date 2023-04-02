//
//  GameRecordModel.swift
//  MovieQuiz
//
//  Created by Mir on 27.03.2023.
//

import UIKit

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
