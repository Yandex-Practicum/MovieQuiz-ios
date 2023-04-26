//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Aleksey Shaposhnikov on 25.04.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }

    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }

    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }

    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
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
                let bestGame = try? decoder.decode(GameRecord.self, from: data) else {
                return nil
            }
            return bestGame
        }

        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }

    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1


        let date = Date()
        let currentGame = GameRecord(correct: correct, total: total, date: date)

        if let previousBestGame = bestGame {
            if currentGame > previousBestGame {
                bestGame = currentGame
            }
        } else {
            bestGame = currentGame
        }
    }

    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
}
