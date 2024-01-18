//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 18.12.2023.
//
//

import UIKit

protocol StatisticService {
    func store(currentRound: Round)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
