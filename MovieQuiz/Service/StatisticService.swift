//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ярослав Калмыков on 26.12.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
}

final class StatisticServiceImp {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    private var currentGame: GameRecord?
    
    init(
        userDefaults: UserDefaults = .standard,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
}


extension StatisticServiceImp: StatisticService {
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.correct.rawValue)
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
            if let newValue = newValue{
                let data = try? encoder.encode(newValue)
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    }
    
    var totalAccuracy: Double {
        return total != 0 ? Double(correct) / Double(total) * 100 : 0
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        let date = dateProvider()
        
        let currentGame = GameRecord(correct: count, total: amount, date: date)
        self.currentGame = currentGame
        
        if let previousBestGame = bestGame {
            if currentGame > previousBestGame {
                bestGame = currentGame
            }
        } else {
            bestGame = currentGame
        }
    }
}
