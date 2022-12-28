//
//  StaticsticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Kosov on 28.12.2022.
//

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
