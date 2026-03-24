//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Flymetric on 23.02.2026.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
