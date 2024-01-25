//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Soslan Dzampaev on 22.01.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService{
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    

    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int{
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
            }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int{
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord{
        
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double{
        Double(correct) / Double(total) * 100
    }
    
    func store(correct count: Int, total amount: Int){
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if  currentGame.isBetterThan(bestGame){
            bestGame = currentGame
        }
    }
    
}
