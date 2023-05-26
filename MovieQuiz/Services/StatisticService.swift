//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Владимир Клевцов on 25.5.23..
//

import Foundation

struct GameRecord: Codable {
    
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
}
final class StatisticServiceImplementation: StaticService {
  
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalAccuracy = totalAccuracy + Double(count / amount * 100)
        
    }
    
    var totalAccuracy: Double { get  {
        guard let data = userDefaults.data(forKey: Keys.total.rawValue),
              let total = try? JSONDecoder().decode(Double.self, from: data) else {
            return 0
        }
        return total }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
        }
    }
    
    var gamesCount: Int { get  {
        guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
              let count = try? JSONDecoder().decode(Int.self, from: data) else {
            return 0
        }
        return count }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
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
//    var text: String = "Ваш результат \(correct)/10 \nКоличество сыгранных квизов: \(gamesCount) \nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date)) \nСредняя точность: \(String(format: "%.2f", totalAccuracy))%"
       
   
   
}
