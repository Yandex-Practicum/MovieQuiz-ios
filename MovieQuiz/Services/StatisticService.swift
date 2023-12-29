//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ilya Shirokov on 28.12.2023.
//

import Foundation

class StatisticServiceImplementation: StatisticServiceProtocol {
    
    enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            return Double(correct) / Double(total)
        }
    }
    
    var gameCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(newValue.correct, forKey: Keys.correct.rawValue)
            userDefaults.set(newValue.total, forKey: Keys.total.rawValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gameCount += 1
        
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        
        if !bestGame.comparisonResults(newRecord) {
            bestGame = newRecord
        }
    }
    
}
