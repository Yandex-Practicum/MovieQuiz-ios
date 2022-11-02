//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Тимченко on 29.10.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return rhs.correct > lhs.correct
    }
    let correct: Int //количество правильных ответов
    let total: Int //количество вопросов квиза
    let date: String //дата завершения раунда
}

protocol StatisticService {
    var correct: Int { get set }
    var totalAccuracy: Double { get } //точность правильных ответов
    var gamesCount: Int { get set } //кол-во игр
    var bestGame: GameRecord { get } //лучшая игра
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var correct: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
                  let correct = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return correct
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить общее кол-во правильных ответов")
                return
            }
            userDefaults.set(data, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let total = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }
            return total
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить среднюю результативность")
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
                print("Невозможно сохранить кол-во игр")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date().dateTimeString)
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат лучшей игры")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) { //сохранение лучшего результата
        let newResult = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        
        if newResult > bestGame {
            print("\(newResult.correct) > \(bestGame.correct)")
            bestGame = newResult
        }
        totalAccuracy = 100 * (Double (correct) / Double (10 * gamesCount))
    }
}
