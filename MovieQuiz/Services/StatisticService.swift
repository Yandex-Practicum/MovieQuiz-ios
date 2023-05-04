//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by DANCECOMMANDER on 03.05.2023.
//

import Foundation

protocol StatisticService {
    var total: Int { get }
    var correct: Int { get }
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        correct += count
        gamesCount += 1
        total += amount
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        if newGame.correct > bestGame.correct {
            bestGame = newGame
        }
    }
    
    var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return (userDefaults.double(forKey: Keys.correct.rawValue) * 100) / Double(total)
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
    
}

struct GameRecord: Codable, Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    let correct: Int // Количество правильных ответов
    let total: Int // Количество вопросов квиза
    let date: Date // Дата завершения раунда
}


