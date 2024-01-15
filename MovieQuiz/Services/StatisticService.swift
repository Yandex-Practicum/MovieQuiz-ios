//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 18.12.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


