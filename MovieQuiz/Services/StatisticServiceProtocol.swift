//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Кирилл on 01.10.2023.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    var totalAccuracy: Double { get }
    func store(correct count: Int, total amount: Int)
}
