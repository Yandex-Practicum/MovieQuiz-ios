//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 16.02.2024.
//

import Foundation

final class StatisticServiceImpl: StatisticServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        if count > self.bestGame.correct {
            self.bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        let correctStored = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correctStored + count, forKey: Keys.correct.rawValue)
        
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.setValue(total + amount, forKey: Keys.total.rawValue)
        
        userDefaults.setValue(self.gamesCount + 1, forKey: Keys.gamesCount.rawValue)
    }
    
    var totalAccuracy: Double {
        let correctTotal = userDefaults.double(forKey: Keys.correct.rawValue)
        let count = userDefaults.double(forKey: Keys.total.rawValue)
        return (correctTotal / count) * 100
    }
    
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.setValue(newValue, forKey: Keys.gamesCount.rawValue) }
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
            userDefaults.setValue(data, forKey: Keys.bestGame.rawValue)
        }
    }
}

extension StatisticServiceImpl {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}
