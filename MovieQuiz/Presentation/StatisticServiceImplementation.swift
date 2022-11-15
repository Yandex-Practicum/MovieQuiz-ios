//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 14.11.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to save value")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            
        }
    }
    var gamesCount: Int {
        get {
            var count = 0
            count += 1
        }
    }
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        <#code#>
    }
    
    init(bestGame: GameRecord, totalAccuracy: Double, gamesCount: Int) {
        self.bestGame = bestGame
        self.totalAccuracy = totalAccuracy
        self.gamesCount = gamesCount
    }
} 
