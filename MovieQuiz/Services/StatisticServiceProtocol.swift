//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Слава Шестаков on 06.11.2022.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
