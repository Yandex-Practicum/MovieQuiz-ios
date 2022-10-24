//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 18.10.2022.
//

import Foundation


protocol StatisticService {
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
    
    func store(correct count: Int, total amount: Int)
}

