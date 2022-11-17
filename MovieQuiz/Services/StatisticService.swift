//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Marina on 24.10.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set}
    var bestGame: GameRecord { get set}
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
            let totalAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
            
            return Double(correctAnswers) / Double(totalAnswers) * 100
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
        let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
        let totalAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(correctAnswers + count, forKey: Keys.correct.rawValue)
        userDefaults.set(totalAnswers + amount, forKey: Keys.total.rawValue)
        let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < gameRecord {
            bestGame = gameRecord
        }
    }
    
}
