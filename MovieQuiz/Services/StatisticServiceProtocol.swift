//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Kuimova Olga on 21.04.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get } //средняя точность правильных ответов за все игры в процентах
    var gamesCount: Int { get } //кол-во завершенных игр
    var bestGame: GameRecord { get } //информация о лучшей попытке
}
