//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 10/30/22.
//

import Foundation
protocol StatisticService {
    var totalAccuracy: Double {get set}
    var gamesCount: Int {get set}
    var bestGame: GameRecord {get}
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
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
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return .init(correct: record.correct, total: record.total, date: record.date)
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
        let result: Double
        count > 0 && amount > 0 ? (result = (Double(count) / Double(amount))) : (result = self.totalAccuracy)
        print(result)
        let totalAccuracy = ((self.totalAccuracy * (Double(self.gamesCount - 1)) + result * 100) / (Double(self.gamesCount)))
        self.totalAccuracy = totalAccuracy
        if  count > self.bestGame.correct && amount >= self.bestGame.total {
            self.bestGame = .init(correct: count, total: amount, date: Date())
        } else {
            return
        }
    }
}
struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
}
