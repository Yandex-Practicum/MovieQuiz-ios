//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Mishana on 12.07.2023.
//

import Foundation


protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
}


final class StatisticServiceImplementation {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    private let dateProvider: () -> Date
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        dateProvider: @escaping () -> Date = { Date() },
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()) {
            self.dateProvider = dateProvider
            self.decoder = decoder
            self.encoder = encoder
        }
}

extension StatisticServiceImplementation: StatisticService {
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
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
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let date = dateProvider()
        let currentBastGame = GameRecord(correct: correct, total: total, date: date)
        if let previousBestGame = bestGame {
            if currentBastGame > previousBestGame {
                bestGame = currentBastGame
            }
        } else {
            bestGame = currentBastGame
        }
    }
}
