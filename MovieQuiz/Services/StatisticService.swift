//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ina on 25/03/2023.
//

import Foundation
    
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var total: Int { get set }
    
    func store(correct: Int, count: Int, total: Int)
}

final class StatisticServiceImplementation {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        userDefaults: UserDefaults = .standard,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
    }
}

extension StatisticServiceImplementation: StatisticService {
    var bestGame: GameRecord {
        get {
            if let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let bestGame = try? decoder.decode(GameRecord.self, from: data) {
                    return bestGame
                }
            else {
                return GameRecord(correct: 0, total: 0, date: Date())
            }
        }
        set {
            guard
                let data = try? encoder.encode(newValue)
            else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            Int(userDefaults.integer(forKey: Keys.gamesCount.rawValue))
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
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
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    func store(correct: Int, count: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let currentGameRecord = GameRecord (correct: correct, total: total, date: Date())
        
            if currentGameRecord > bestGame {
                bestGame = currentGameRecord
        }
    }
}

