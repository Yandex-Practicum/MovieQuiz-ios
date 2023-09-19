//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by LERÄ on 19.09.23.
//

import Foundation

protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    // метод сравнения по кол-ву верных ответов
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}

