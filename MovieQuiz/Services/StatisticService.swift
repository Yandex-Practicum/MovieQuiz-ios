//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Кирилл on 01.10.2023.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
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
    var bestGame: GameRecord? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date(timeIntervalSince1970: 0))
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        Double(correct)/Double(total)*100
    }
    func store(correct count: Int, total amount : Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if let lastGame = bestGame {
            if currentGame.correct > lastGame.correct {
                bestGame = currentGame
            }
        } else {
            bestGame = currentGame
        }
    }
}
