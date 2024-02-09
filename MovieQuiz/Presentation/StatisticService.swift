//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by kamila on 09.02.2024.
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
    
    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case bestGame, correct, total, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        } set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        self.totalAccuracy = Double(count)/Double(amount) * 100
        self.gamesCount += 1
        let current = GameRecord(correct: count, total: amount, date: Date())
        if current.isBetterThan(bestGame) {
            bestGame = current
        }
    }
}
