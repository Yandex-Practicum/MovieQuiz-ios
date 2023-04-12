//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Марина Писарева on 26.12.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    var totalAccuracy: Double {
            get {
                let correctCount = Double(UserDefaults.standard.integer(forKey: Keys.correct.rawValue))
                let total = Double(UserDefaults.standard.integer(forKey: Keys.total.rawValue))
                return 100 * (correctCount / total)
            }
        }
    
    var correct: Int {
         return  UserDefaults.standard.integer(forKey: Keys.correct.rawValue)
     }

     var total: Int {
         return  UserDefaults.standard.integer(forKey: Keys.total.rawValue)
     }
    
    private enum Keys: String {
           case total, correct, bestGame, gamesCount
    }
    
    private(set) var gamesCount: Int {
        get {
            let count = UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data =  UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
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
            
            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        UserDefaults.standard.set(self.total + amount, forKey: Keys.total.rawValue)
        UserDefaults.standard.set(self.correct + count, forKey: Keys.correct.rawValue)

        if bestGame < GameRecord(correct: count, total: amount, date: Date()) {
            self.bestGame = GameRecord(correct: count, total: amount, date: Date())
        } else {
            self.bestGame = bestGame
        }
    }
    
}


protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
