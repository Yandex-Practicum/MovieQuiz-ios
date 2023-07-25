//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ivan on 16.07.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct,
             total,
             bestGame,
             gamesCount
    }
    private let userDefaults = UserDefaults.standard
    private var date = { return Date() }
    private var correct: Int {
        return userDefaults.integer(forKey: Keys.correct.rawValue)
    }
    private var total: Int {
        return userDefaults.integer(forKey: Keys.total.rawValue)
    }
    var totalAccuracy: Double {
        get {
            let correctCount = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            return 100 * (correctCount / total)
        }
    }
    var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
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
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        userDefaults.set(self.total + amount, forKey: Keys.total.rawValue)
        userDefaults.set(self.correct + count, forKey: Keys.correct.rawValue)
        
        if bestGame < GameRecord(correct: count, total: amount, date: date()) {
            self.bestGame = GameRecord(correct: count, total: amount, date: date())
        } else {
            self.bestGame = bestGame
        }
    }
    
}

