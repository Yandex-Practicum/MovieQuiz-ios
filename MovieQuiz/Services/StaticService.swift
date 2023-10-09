//
//  StaticService.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 09.10.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
}



final class StatisticServiceImplementation {
    
    //MARK: - Private Properties
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    //MARK: - Initializers
    
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

extension StatisticServiceImplementation: StatisticService {
    
    //MARK: - Public Properties
    
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
                  let record = try? decoder.decode(GameRecord.self, from: data) else {
                return nil
            }
            
            return record
        }
        
        set {
            guard let data = try? encoder.encode(newValue) else {
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    //MARK: - Public Methods
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1

        let currentBestGame = GameRecord(correct: correct, total: total, date: dateProvider())
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
