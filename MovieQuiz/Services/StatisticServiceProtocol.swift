//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Эльдар Айдумов on 28.05.2023.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store (correct count: Int, total: Int)
}
