//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Леонид Турко on 30.01.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
