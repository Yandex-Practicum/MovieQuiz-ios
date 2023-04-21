//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Kuimova Olga on 20.04.2023.
//

import Foundation


final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    
    var correct: Int{
        get {
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            return correct
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int{
        get {
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            return total
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double{
        get{
            return Double(correct)/Double(total) * 100
        }
    }
    
    var gamesCount: Int{
        get {
            let games = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return games
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
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
    
    
    func store(correct count: Int, total amount: Int) {
        self.gamesCount += 1
        self.correct += count
        self.total += amount
        
        let currentbestGame = GameRecord(correct: count, total: amount, date: Date())
        let lastbestGame = bestGame
        let newBestGame = currentbestGame.comparisonResults(currentResult: currentbestGame, bestResult: lastbestGame)
        bestGame = newBestGame
        
    }
} 
