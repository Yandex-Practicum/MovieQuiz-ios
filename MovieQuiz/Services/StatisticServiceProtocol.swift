//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

protocol StatisticServiceProtocol {
    
    //Общее общая статистика игры
    var totalAccurancy: Double { get }
    //Общий счетчик игр
    var gamesCount: Int { get }
    //Лучшая игра
    var bestGame: GameRecord { get set }
    
    func store(correct count: Int, total amount: Int)
    
}
