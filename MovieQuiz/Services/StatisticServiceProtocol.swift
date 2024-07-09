//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 05/11/2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: String
    
    func compareTwo(prevRec: GameRecord) -> Bool {
        if self.correct > prevRec.correct { return true }
        else { return false }
    }
}

