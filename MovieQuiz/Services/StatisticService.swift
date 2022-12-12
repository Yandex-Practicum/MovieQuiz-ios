//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 08.12.2022.
//

import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
    
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

protocol StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
}

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    // сохраняет результаты игры
    func store(correct count: Int, total amount: Int) {
        self.correct = count + self.correct
        self.total = amount + self.total
        
        if let bestGame = bestGame {
            if Double(count) / Double(amount) >= Double(bestGame.correct) / Double(bestGame.total) {
                self.bestGame = GameRecord(correct: count, total: amount, date: Date())
            }
        } else {
            self.bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        self.gamesCount = gamesCount + 1
    }
    private let userDefaults = UserDefaults.standard
    
    // всего вопросов отвечено
    var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    // точность ответов
    var totalAccuracy: Double {
        return Double(correct) / Double(total) * 100
    }
    
    // количество правильных ответов
    var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    // всего сыграно игр
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // лучший результат
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return nil
                
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
