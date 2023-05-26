//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Admin on 24.05.2023.
//

import Foundation

protocol StatisticService {
    /// точность правильных ответов %
    var totalAccuracy: Double { get }
    /// количество игр
    var gameCount: Int { get }
    /// лучшая игра
    var bestGame: BestGame? { get }
    
    /// метод для сохранения текущего результата игры
    func store(correct: Int, total: Int)
}


final class StatisticServiceImpl {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    init(userDefaults: UserDefaults = .standard,
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

extension StatisticServiceImpl: StatisticService {
    
    
    var gameCount: Int {
        // своего рода функции для получения
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        // и присвоения данных
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
    
    var bestGame: BestGame? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let bestGame = try? decoder.decode(BestGame.self, from: data) else {
                return nil
                
            }
            return bestGame
        }
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    // метод хранения правильных ответов
    func store(correct: Int, total: Int) {
        //  userDefaults.set(correct, forKey: "savedCount"
        self.correct += correct
        self.total += total
        self.gameCount += 1
        let date = dateProvider()
        let currentBestGame = BestGame(correct: correct, total: total, date: date)
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
