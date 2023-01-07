//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 06.01.2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccuracy.rawValue),
                  let gamesCount = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }
            return gamesCount
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно записать точность")
                return
            }
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let gamesCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return gamesCount
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно записань количество игр")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correctAnswers: 0, totalAnswers: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно записать рекорд")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let oldRecord = bestGame
        let newRecord = GameRecord(correctAnswers: count, totalAnswers: amount, date: Date())
        if totalAccuracy == 0 {
            totalAccuracy = Double(count) / Double(amount) * 100
        } else {
            totalAccuracy = ((totalAccuracy) + (Double(count) / Double(amount)) * 100) / 2
        }
        gamesCount += 1
        
        
        if oldRecord < newRecord {
            bestGame = oldRecord
        } else {
            bestGame = newRecord
        }
        
        
    }
    
    
    private enum Keys: String {
        case correctAnswers, totalAccuracy, bestGame, gamesCount
    }
}


protocol StatisticService {
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}


struct GameRecord: Codable, Comparable {
    
    var correctAnswers: Int
    var totalAnswers: Int
    var date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        if lhs.correctAnswers != rhs.correctAnswers {
            return rhs.correctAnswers < lhs.correctAnswers
        } else if lhs.date != rhs.date {
            return rhs.date < lhs.date
        } else {
            return rhs.totalAnswers < lhs.totalAnswers
        }
    }
    
    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correctAnswers == rhs.correctAnswers && lhs.date == rhs.date && lhs.totalAnswers == rhs.totalAnswers
    }
}
