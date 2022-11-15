//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Veniamin on 15.11.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get } // средняя точность
    var gamesCount: Int { get } // кол-во сыгранных квизов
    var bestGame: GameRecord { get } // рекорд
}
