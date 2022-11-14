//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 10/30/22.
//

import Foundation
protocol StatisticService {
    var totalAccuracy: Double {get set}
    //var gamesCount: Int {get set}
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
    
    /*var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }*/
    
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
    // Функция для инкрементирования счётчика игр
    func gamesCounterUp () {
        let gamesCount = gamesCounterRead() + 1
        userDefaults.set(gamesCount, forKey: Keys.gamesCount.rawValue)
    }
    // Функция для чтения счётчика игр
    func gamesCounterRead () -> Int{
        return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
    }
    
    func store(correct count: Int, total amount: Int) {
        // Пременная для хранения соотношения правильных ответов к общему числу ответов
        let result: Double
        // Если колличество правильных ответов больше 0 и колличество ответов в квизе больше 0, то
        count > 0 && amount > 0 ? (result = (Double(count) / Double(amount))) : (result = self.totalAccuracy)
        let totalAccuracy = ((self.totalAccuracy * (Double(self.gamesCounterRead() - 1)) + result * 100) / (Double(self.gamesCounterRead())))
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
