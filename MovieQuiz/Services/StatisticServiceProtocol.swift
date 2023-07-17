//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 13.07.2023.
//

import Foundation

protocol StatisticService {
    var correctQuestions: Int { get }
    var totalQuestions: Int { get }
    var accuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
