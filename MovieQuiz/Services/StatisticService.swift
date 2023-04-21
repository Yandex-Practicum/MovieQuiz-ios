//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 20.04.2023.
//

import Foundation
import UIKit

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int) 
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        return Double(correct) / Double(total) * 100
    }

    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }

    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return .init(correct: 0, total: 0, date: Date().dateTimeString)
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
        let prevCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        let prevTotal = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(count + prevCorrect, forKey: Keys.correct.rawValue)
        userDefaults.set(amount + prevTotal, forKey: Keys.total.rawValue)
        
        let gameRecord = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        if bestGame <= gameRecord {
            bestGame = gameRecord
            gamesCount = gamesCount + 1
        }
    }
}
