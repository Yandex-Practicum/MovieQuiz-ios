//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 26.09.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
