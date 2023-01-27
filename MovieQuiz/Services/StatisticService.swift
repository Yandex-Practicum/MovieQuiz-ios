//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexey on 19.01.2023.
//

import Foundation


struct GameRecord: Codable {
    
    let correct: Int
    let total: Int
    let date: Date
    
}

extension GameRecord: Comparable {
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        if lhs.total == 0 {
            return true
        }
        let lhsRatio: Double = Double(lhs.correct) / Double(lhs.total)
        let rhsRatio: Double = Double(rhs.correct) / Double(rhs.total)
        
        return lhsRatio < rhsRatio
    }
}


protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord(correct: count, total: amount, date: Date())

        if bestGame < newGame {
            bestGame = newGame
        }
        if gamesCount != 0 { // если игра первая то totalAccuracy равно точности в первой игре
            totalAccuracy = (totalAccuracy + (Double(newGame.correct) / Double(newGame.total))) / 2.0 // среднее арифметическое между средней  и новой игрой
        } else {
            totalAccuracy = (Double(newGame.correct) / Double(newGame.total)) // если
        }
        gamesCount += 1
    }
    
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
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
}

