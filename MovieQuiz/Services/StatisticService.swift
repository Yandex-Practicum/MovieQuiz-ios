//
//  StaticService.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 12.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case bestGame
        case gamesCount
    }
    
    private var correct = 0
    private var total = 0
    
    var totalAccuracy: Double {
        get {
            (Double(correct) / Double(total)) * 100
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
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
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord (correct: count,
                                  total: amount,
                                  date: Date())
        
        correct = newGame.correct
        total = newGame.total
        
        if gamesCount == 0 {
            bestGame = newGame
        } else
        if newGame > bestGame  {
            bestGame = newGame
        }
        gamesCount += 1
    }
}
