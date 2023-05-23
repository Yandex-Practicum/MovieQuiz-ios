//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Dmitrii on 23.05.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compare(other: GameRecord) -> Bool {
        if self.correct < other.correct {
            return true
        } else {
            return false
        }
    }
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set } // средняя точность
    var gamesCount: Int { get set } // кол-во сыгр. квизов
    var bestGame: GameRecord { get set } // рекорд
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
        
    private let userDefaults = UserDefaults.standard
        
    var totalAccuracy: Double {
        get {
            return self.userDefaults.double(forKey: Keys.total.rawValue)
        }
        
        set {
            self.userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return self.userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            self.userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = self.userDefaults.data(forKey: Keys.bestGame.rawValue),
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
        self.totalAccuracy = Double(count * 100 / 10)
        
        let newRecord = GameRecord(correct: count, total: amount + 1, date: Date())
        
        if self.bestGame.compare(other: newRecord) == true {
            self.bestGame = newRecord
        }
    }
}
