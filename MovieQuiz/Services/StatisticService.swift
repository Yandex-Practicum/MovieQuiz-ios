//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by  admin on 23.08.2022.
//

import Foundation
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
final class StatisticServiceImplementation: StatisticService {
    var totalAccuracy: Double {
        get {
            guard let rawCorrects = userDefaults.string(forKey: Keys.correct.rawValue),
            let rawTotal = userDefaults.string(forKey: Keys.total.rawValue) else {
                return 0.0
            }
            guard let corrects = Double(rawCorrects),
            let total = Double(rawTotal) else {
                return 0.0
            }
            guard total > 0 else {
                return 0.0
            }
            return (corrects / total) * 100.0
        }
    }
    private(set) var gamesCount: Int {
        get {
            guard let data = userDefaults.string(forKey: Keys.gamesCount.rawValue),
            let val = Int(data) else {
                return 0
            }
            return val
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
            return .init(correct: record.correct, total: record.total, date: record.date)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to store the result")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            // print("Stored UserDefault bestGame = \(newValue)")
        }
    }
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    func store(correct count: Int, total amount: Int) {
        // print("store(correct: \(count), total: \(amount))")
        if userDefaults.string(forKey: Keys.correct.rawValue) == nil {
            userDefaults.set(count, forKey: Keys.correct.rawValue)
            // print("Stored UserDefault correct = \(count)")
        } else {
            guard let oldValue = userDefaults.string(forKey: Keys.correct.rawValue) else {
                return
            }
            guard let oldValue = Int(oldValue) else {
                return
            }
            // print("oldValue for count (correct) = \(oldValue)")
            userDefaults.set(oldValue + count, forKey: Keys.correct.rawValue)
            // print("Stored UserDefault correct = \(oldValue + count)")
        }
        
        if userDefaults.string(forKey: Keys.total.rawValue) == nil {
            userDefaults.set(amount, forKey: Keys.total.rawValue)
            // print("Stored UserDefault total (init) = \(amount)")
        } else {
            guard let oldValue = userDefaults.string(forKey: Keys.total.rawValue) else {
                return
            }
            guard let oldValue = Int(oldValue) else {
                return
            }
            // print("oldValue1 for amount (total) = \(oldValue)")
            userDefaults.set(oldValue + amount, forKey: Keys.total.rawValue)
            // print("Stored UserDefault total = \(oldValue + amount)")
        }
        
        if userDefaults.string(forKey: Keys.gamesCount.rawValue) == nil {
            userDefaults.set(1, forKey: Keys.gamesCount.rawValue)
            print("Stored UserDefault gamesCount = 1")
        } else {
            guard let oldValue = userDefaults.string(forKey: Keys.gamesCount.rawValue) else {
                return
            }
            guard let oldValue = Int(oldValue) else {
                return
            }
            // print("oldValue for gamesCount = \(oldValue)")
            userDefaults.set(oldValue + 1, forKey: Keys.gamesCount.rawValue)
            // print("Stored UserDefault total = \(oldValue + 1)")
        }
        
        let currentGame: GameRecord = GameRecord(correct: count, total: amount, date: Date())
        if self.bestGame < currentGame {
            self.bestGame = currentGame
        }
    }
}
