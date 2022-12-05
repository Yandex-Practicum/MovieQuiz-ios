//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 03.12.2022.
//

import Foundation

protocol StatisticServiceProtocol {

    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }

    func store(correct count: Int, total amount: Int)

}
