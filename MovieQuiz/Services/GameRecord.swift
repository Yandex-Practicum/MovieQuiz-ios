//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Анастасия Хоревич on 09.07.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
