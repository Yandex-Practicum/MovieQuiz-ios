//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by tommy tm on 20.12.2022.
//

import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
}





final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    var total: Int {
        get {
            guard let totalString = userDefaults.string(forKey: Keys.total.rawValue),
                  let totalValue = Int(totalString)
            else {
                return 0
            }
            return totalValue
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            guard let correctString = userDefaults.string(forKey: Keys.correct.rawValue),
                  let correctValue = Int(correctString)
            else {
                return 0
            }
            return correctValue
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    
    
    var totalAccuracy: Double {
        get {
            return total != 0 ? Double(correct) / Double(total) : 0
        }
    }
    
    var gamesCount: Int{
        get {
            guard let countString = userDefaults.string(forKey: Keys.gamesCount.rawValue),
                  let count = Int(countString)
            else {
                return 0
            }
            return count
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
        let newResult = GameRecord(correct: count, total: amount, date: Date())
        bestGame = newResult > bestGame ? newResult : bestGame
        total += amount
        correct += count
        print("total: \(total), correct: \(correct)")
        
        self.gamesCount += 1
        
    }
}


