//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Mir on 27.03.2023.
//

import UIKit

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }

    func store(correct: Int, total: Int)
}

final class StatisticServiceImplementation {
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(userDefaults: UserDefaults, decoder: JSONDecoder, encoder: JSONEncoder) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
    }

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}

extension StatisticServiceImplementation: StatisticService {
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
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
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey:Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from:data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                assertionFailure("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1

        let currentBestGame = GameRecord(correct: correct,
                                         total: total,
                                         date: Date())
        if let previousBestGame = bestGame {
            if currentBestGame >= previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
