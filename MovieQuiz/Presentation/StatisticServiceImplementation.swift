//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 14.11.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
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
                print("Unable to save value")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            let getCorrect = Double((userDefaults.integer(forKey: Keys.correct.rawValue)))
            let getTotal = Double((userDefaults.integer(forKey: Keys.total.rawValue)))
            return (getCorrect/getTotal) * 100
        }
    }
    var gamesCount: Int {
        get {
            let data = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return data
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        userDefaults.set(userDefaults.integer(forKey: "correct") + count, forKey: "correct")
        userDefaults.set(userDefaults.integer(forKey: "total") + amount, forKey: "total")
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }
} 
