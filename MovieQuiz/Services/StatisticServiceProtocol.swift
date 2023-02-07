//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Турко on 30.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
