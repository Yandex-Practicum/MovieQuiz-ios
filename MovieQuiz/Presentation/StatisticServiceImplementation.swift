//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 14.11.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private var correct: Double {
        get {
            userDefaults.double(forKey: Keys.correct.rawValue)
        }
    }
    private var total: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
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
                print("Unable to save value")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            return (correct / total) * 100
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
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        userDefaults.set(Int(correct) + count, forKey: "correct")
        userDefaults.set(Int(total) + amount, forKey: "total")
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }
} 
