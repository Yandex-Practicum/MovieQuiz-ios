//
//  StatisticService.swift
//  MovieQuiz

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var correct: Int { get }
    var total: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    var gamesCount: Int {
        get {
            return self.userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
        set {
            self.userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var correct: Int {
        get {
            return self.userDefaults.integer(forKey: Keys.correct.rawValue)
            }
        set {
            self.userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    var total: Int {
        get {
            return self.userDefaults.integer(forKey: Keys.total.rawValue)
            }
        set {
            self.userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var totalAccuracy: Double {
        get { Double(correct) * 100 / Double (total) }
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
        self.gamesCount += 1
        self.correct += count
        self.total += amount
        let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        if gameRecord.isBetterThan(self.bestGame) {
            self.bestGame = gameRecord
        }
    }
}

