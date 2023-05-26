//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by DANCECOMMANDER on 03.05.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard

    // MARK: - Public methods
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1

        let game = GameRecord(correct: count, total: amount, date: Date())

        if game.isBetterThan(bestGame) {
            bestGame = game
        }
    }

    // MARK: - Public properties
    // Средняя точность правильных ответов в процентах
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }

    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
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

    // MARK: - Private properties
    private var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }

        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }

    private var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }

        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
}
