//
//  StatisticServiceProtocol.swift
//  MovieQuiz

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var correct: Int { get }
    var total: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
