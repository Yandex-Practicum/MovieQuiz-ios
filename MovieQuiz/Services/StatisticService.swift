import Foundation
import UIKit

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
    var totalCorrectAnswers: Int { get set }
    var totalAmount: Int { get set }
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalCorrectAnswers, totalAmount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalCorrectAnswers: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalCorrectAnswers.rawValue),
                  let totalCorrectAnsw = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return totalCorrectAnsw
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to save a result")
                return
            }
            userDefaults.set(data, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
        
    var totalAmount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAmount.rawValue),
                  let totalAm = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return totalAm
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to save a result")
                return
            }
            userDefaults.set(data, forKey: Keys.totalAmount.rawValue)
        }
    }
    
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let totalAccuracy = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0.0
            }
            return totalAccuracy
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to save a result")
                return
            }
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let gamesCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return gamesCount
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to save a result")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
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
                print("Impossible to save a result")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame: GameRecord = GameRecord(correct: count, total: amount, date: Date())
        if bestGame.isBetterThan(currentGame) {
            bestGame = currentGame
        }
        
        totalCorrectAnswers += count
        totalAmount += amount
        gamesCount += 1
        
        totalAccuracy = Double(totalCorrectAnswers) / Double(totalAmount) * 100
    }
}
