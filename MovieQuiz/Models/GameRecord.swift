//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Aleksey Shaposhnikov on 25.04.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date

    private var accuracy: Double {
        guard total != 0  else {
            return 0
        }

        return Double(correct / total)
    }

    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
