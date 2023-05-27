//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Владимир Клевцов on 25.5.23..
//

import Foundation

struct GameRecord: Codable, Comparable {
    
    let correct: Int
    let total: Int
    let date: Date
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}

protocol StaticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var correct: Int { get }
    var total: Int { get }
}
final class StatisticServiceImplementation: StaticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct: Int, total: Int) {
        gamesCount += 1
        self.correct += correct
        self.total += total
        
        let currentBestGame = GameRecord(correct: correct, total: total, date: Date())
        if currentBestGame > bestGame {
            bestGame = currentBestGame
        }
        print(totalAccuracy, correct, total)
        //        totalAccuracy = (totalAccuracy + Double(count / amount * 100)) / Double(gamesCount)
        //        print(gamesCount, totalAccuracy, count, amount)
    }
    
    var total: Int { get  {
        userDefaults.integer(forKey: Keys.total.rawValue)
    }
        set {
            userDefaults.set(newValue, forKey:Keys.total.rawValue)
        }
    }
    var correct: Int { get  {
        userDefaults.integer(forKey: Keys.correct.rawValue)
    }
        set {
            userDefaults.set(newValue, forKey:Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int { get  {
        userDefaults.integer(forKey: Keys.gamesCount.rawValue)
    }
        set {
            userDefaults.set(newValue, forKey:Keys.gamesCount.rawValue)
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
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
}
