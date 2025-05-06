//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by macOS on 30.09.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
