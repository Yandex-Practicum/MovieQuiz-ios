//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Andrey Sysoev on 02.10.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        if lhs.total == 0 {
            return true
        }
        
        let lhsCorrectPercent = Double(lhs.correct) / Double(lhs.total)
        let rhsCorrectPercent = Double(rhs.correct) / Double(rhs.total)
        
        return lhsCorrectPercent < rhsCorrectPercent
    }
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case totalAccuracy, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
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
        let gameRecord = GameRecord(
            correct: count,
            total: amount,
            date: Date())
        
        if bestGame < gameRecord {
            bestGame = gameRecord
        }
        
        gamesCount += 1
        totalAccuracy = updateTotalAccuracy(currentGameAccuracy: Double(count) / Double(amount) * 100.0)
    }
    
    private func updateTotalAccuracy(currentGameAccuracy: Double) -> Double {
        ((totalAccuracy * Double(gamesCount - 1)) + currentGameAccuracy) / Double(gamesCount)
    }
}
