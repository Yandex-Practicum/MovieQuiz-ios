//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by LERÄ on 19.09.23.
//

import Foundation

protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
}
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    // метод сравнения по кол-ву верных ответов
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
final class StatisticServiceImplementation {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct: Int, total: Int) {
        
        if total > 0 {
            totalAccuracy = Double(correct) / Double(total) * 100.0
        } else {
            totalAccuracy = 0.0 
        }
        gamesCount += 1
        
        let currentGame = GameRecord(correct: correct, total: total, date: Date())
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
                  let accuracy = try? JSONDecoder().decode(Double.self, from: data) else { return 0.0}
            return accuracy
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить totalAccuracy")
                return
            }
            
            userDefaults.set(data, forKey: Keys.correct.rawValue)
            //userDefaults.removeObject(forKey: Keys.correct.rawValue)
            //userDefaults.synchronize()
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {return 0}
            
            return count
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить gamesCount")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
            //userDefaults.removeObject(forKey: Keys.gamesCount.rawValue)
            //userDefaults.synchronize()
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
            //userDefaults.removeObject(forKey: Keys.bestGame.rawValue)
            //userDefaults.synchronize()
            
        }
    }
}
