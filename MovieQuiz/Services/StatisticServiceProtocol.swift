//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Ilya Shirokov on 28.12.2023.
//

import Foundation

protocol StatisticServiceProtocol {
    //средняя точность
    var totalAccuracy: Double { get }
    //колличество игр за все время
    var gameCount: Int { get }
    //лучшая игра(результат/дата)
    var bestGame: GameRecord { get }
    
    //Метод для сохранения текущего результата игры
    func store(correct count: Int, total amount: Int)
}
