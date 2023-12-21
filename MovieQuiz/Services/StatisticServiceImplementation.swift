//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 18.12.2023.
//

import UIKit

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
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
    
    // общая точность
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    // количество раундов
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // лучшая игра
    var bestGame: GameRecord {
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
    
    func store(currentRound: Round) {
        guard let currentGameRecord = currentRound.getGameRecord() else {
            return
        }
        
        self.correct += currentGameRecord.correct
        self.total += currentGameRecord.total
        self.gamesCount += 1
        
        if !bestGame.comparisonCorrect(currentGame: currentGameRecord) {
            bestGame = currentGameRecord
        }
    }
}
