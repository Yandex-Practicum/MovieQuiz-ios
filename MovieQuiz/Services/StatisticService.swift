//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Olga Vasileva on 04.06.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gameCount: Int { get }
    var bestGame: BestGame? { get }
    
    func store(correct: Int, total: Int)
}

final class StatisticServiceImpl {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        userDfauls:  UserDefaults = .standard,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.userDefaults = userDfauls
        self.decoder = decoder
        self.encoder = encoder
        
    }
}

extension StatisticServiceImpl: StatisticService {
    
    var gameCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var correct: Int {
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
    
    var bestGame: BestGame? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let bestGame = try? decoder.decode(BestGame.self, from: data)
            else {
                assertionFailure("error massange")
                return nil
            }
            return bestGame
        }
        
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double{
        Double (correct) / Double(total) * 100
    }
    
    func store(correct: Int, total: Int){
        self.correct += correct
        self.total += total
        self.gameCount += 1
        
        let currentBestGame = BestGame(correct: correct, total: total, date: Date() )
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
                  else {
                bestGame = currentBestGame
            }
        }
    }
    
}
