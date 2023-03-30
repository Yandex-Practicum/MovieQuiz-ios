//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Mir on 27.03.2023.
//

import UIKit

final class StatisticServiceImplementation: StatisticService {
    
    var totalAccuracy: Double {
        get {
            let value = userDefaults.double(forKey: Keys.accuracy.rawValue)
                return value
        }
    }
    
    var gamesCount: Int {
        get {
            let data = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
                return data
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
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
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, accuracy
    }
    
    func store(correct count: Int, total amount: Int) {
        let previousGamesCount = self.gamesCount
        let newGamesCount: Int = previousGamesCount + 1
        let newTotalAccuracy: Double = (Double(previousGamesCount * amount) * self.totalAccuracy + Double(count)) / Double(newGamesCount * amount)
        let newBestGame = self.bestGame.compareRecords(correct: count, total: amount, date: Date())
        
        userDefaults.set(newTotalAccuracy, forKey: Keys.accuracy.rawValue)
        userDefaults.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
        userDefaults.set(try! JSONEncoder().encode(newBestGame), forKey: Keys.bestGame.rawValue)
    }
}

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
