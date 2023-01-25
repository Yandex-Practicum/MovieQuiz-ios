//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Иван Иванов on 11.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get } 
}

final class StatisticServiceImplementation: StatisticService {//класс для ведения статистики
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    private var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
            // userDefaults.removeObject(forKey: Keys.correct.rawValue)
        }
    }
    
    private var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
            // userDefaults.removeObject(forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return Double(correct)/Double(total)*100
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            // userDefaults.removeObject(forKey: Keys.gamesCount.rawValue)
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
            // userDefaults.removeObject(forKey: Keys.bestGame.rawValue)
        }
    }
    func store(correct count: Int, total amount: Int) {
        
        let newGame = GameRecord(correct: count,
                                 total: amount,
                                 date: Date())
        
        if gamesCount == 0 {
            bestGame = newGame
        }
        
        if newGame > bestGame  {
            bestGame = newGame
        }
        correct += newGame.correct  // сохранить корректные ответы за все время
        total += newGame.total  // сохранить количество вопросов за все время
        gamesCount += 1
    }
}

