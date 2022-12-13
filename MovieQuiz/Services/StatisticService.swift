//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Gennadii Kulikov on 11.12.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

