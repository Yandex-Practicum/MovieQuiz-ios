//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Видич Анна  on 26.2.23..
//

import Foundation
import UIKit


protocol StatisticService {
    
    var totalAccuracy: Double {get}
    var gamesCount: Int {get set}
    var bestGame: GameRecord {get set}
    func store(correct count: Int, total amount: Int)
}
 
final class StatisticServiceImplementation: StatisticService {
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard

    var totalAccuracy: Double {
            get {
                let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
                let total = userDefaults.integer(forKey: Keys.total.rawValue)
                return (Double(correct) / Double(total)) * 100
            }
        }
    
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
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
    
    var totalScore: Int {
        get { userDefaults.integer(forKey: Keys.total.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.total.rawValue) }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        gamesCount += 1
        totalScore += count
        
        let currentGameRecord = GameRecord(correct: count, total: amount, date: Date())
        let lastGamesRecord = bestGame
        if lastGamesRecord < currentGameRecord {
            bestGame = currentGameRecord
        }
    }
}
    
    
    
    
