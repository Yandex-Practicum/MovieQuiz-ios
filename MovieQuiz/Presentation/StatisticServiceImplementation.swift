//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 14.11.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
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
            
            Double(bestGame.correct / bestGame.total)
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
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        
    }
} 
