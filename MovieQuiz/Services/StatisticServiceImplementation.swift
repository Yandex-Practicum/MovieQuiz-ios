//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 14.09.2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
   
    
    // MARC -- Properties
    var bestGame: BestGame? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(BestGame.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set { guard let data = try? JSONEncoder().encode(newValue) else {
            print("Невозможно сохранить результат")
            return
        }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard total != 0 else {
                return 0
            }
            return  Double(correct) / Double(total) * 100
        }
    }
     
    
    private let userDefaults = UserDefaults.standard
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
    
    // MARC -- Metods
   
    func store (correct: Int, total: Int) {
        self.correct = correct
        self.total = total
        self.gamesCount += 1
        
            let currentBestGame = BestGame(correct: correct, total: total, date: Date())
        
        if let previosBestGame = bestGame { 
            if currentBestGame.correct > previosBestGame.correct {
                bestGame = currentBestGame
            }
        }
    }
}
        
        
    
