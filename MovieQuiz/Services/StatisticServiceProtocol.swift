//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

protocol StatisticServiceProtocol {
    
    var totalAccurancy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }

    func store(correct count: Int, total amount: Int)
    
}
