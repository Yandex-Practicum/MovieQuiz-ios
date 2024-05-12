//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Александр Крапивин on 12.05.2024.
//

import UIKit

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
