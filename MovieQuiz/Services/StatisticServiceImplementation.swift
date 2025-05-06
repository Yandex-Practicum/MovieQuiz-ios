//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 26.09.2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let game = GameRecord(correct: count, total: amount, date: Date())
        if !bestGame.isBetterThan(game) {
            bestGame = game
        }
        if gamesCount == 1 {
            totalAccuracy = Double(count) / Double(amount)
        }
        else {
            totalAccuracy = (totalAccuracy * Double(gamesCount - 1) / Double(gamesCount)) + (Double(count) / Double(amount)) / Double(gamesCount)
        }
        
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
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
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
}
