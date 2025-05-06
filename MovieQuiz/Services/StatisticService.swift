//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 11.12.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: TotalAccuracy? { get }
    var gamesCount: GameCount { get set }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correctKey, totalAccuracyKey, bestGameKey, gamesCountKey
    }
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGameKey.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let newData = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            guard let oldData = userDefaults.data(forKey: Keys.bestGameKey.rawValue),
                  let oldRecord = try? JSONDecoder().decode(GameRecord.self, from: oldData) else {
                userDefaults.set(newData, forKey: Keys.bestGameKey.rawValue)
                return
            }
            
            if newValue >= oldRecord {
                userDefaults.set(newData, forKey: Keys.bestGameKey.rawValue)
            }
        }
    }
    
    private(set) var totalAccuracy: TotalAccuracy? {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccuracyKey.rawValue),
                  let total = try? JSONDecoder().decode(TotalAccuracy.self, from: data) else {
                return nil
            }
            return total
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.totalAccuracyKey.rawValue)
        }
    }
    
    
    var gamesCount: GameCount {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCountKey.rawValue),
                  let game = try? JSONDecoder().decode(GameCount.self, from: data) else {
                return .init(countOfGames: 0)
            }
            return game
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCountKey.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        bestGame = GameRecord(correct: count, total: amount, date: Date())
        guard let oldAccuracy = totalAccuracy?.totalAccuracyOfGame else {
            totalAccuracy = TotalAccuracy(totalAccuracyOfGame: Double(count) / Double(amount))
            return
        }
        totalAccuracy = TotalAccuracy(totalAccuracyOfGame: (oldAccuracy + Double(count) / Double(amount)) / 2)
    }
}


