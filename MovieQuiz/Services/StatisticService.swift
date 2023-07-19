//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Андрей Чупрыненко on 18.07.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    var correct: Int
    var total: Int
    var date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
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
    private let magicNumber = 10.0
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
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
    
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var totalScore: Int {
        get { userDefaults.integer(forKey: Keys.total.rawValue) }
        set { userDefaults.set(newValue,  forKey: Keys.total.rawValue) }
    }
    
    var totalAccuracy : Double {
        get {
            return Double(totalScore) / Double(gamesCount) * magicNumber
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalScore += count
        
        let currentGameRecord = GameRecord(correct: count, total: amount, date: Date())
        let lastGamesRecord = bestGame
        if lastGamesRecord < currentGameRecord {
            bestGame = currentGameRecord
        }
    }
}

