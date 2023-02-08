//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Баир Шаралдаев on 05.02.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    var totalAccuracy: Double {
        get {
            let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
            let totalAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
            return Double(correctAnswers * 100 / totalAnswers)
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
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
    
    func store(correct count: Int, total amount: Int) {
        let currentGameResult = GameRecord(correct: count, total: amount, date: Date())
        if bestGame.isNotRecordAnymore(for: currentGameResult) {
            bestGame = currentGameResult
        }
        gamesCount += 1
        
        var savedCorrectAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
        savedCorrectAnswers += count
        userDefaults.set(savedCorrectAnswers, forKey: Keys.correct.rawValue)
        
        var savedTotalAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
        savedTotalAnswers += amount
        userDefaults.set(savedTotalAnswers, forKey: Keys.total.rawValue)
        
    }
}
