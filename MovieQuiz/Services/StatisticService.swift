//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 05.12.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get set}
    func store(correct count: Int, total amount: Int)
}

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    private(set) var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    private(set) var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
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
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.double(forKey: Keys.correct.rawValue)
            let total = userDefaults.double(forKey: Keys.total.rawValue)
            let result = (correct / total) * 100
            print (correct)
            print (total)
            print (result)
            return (round(result * pow(100.0, 1.0)) / (pow(100.0, 1.0)))
        }
    }
    func store(correct count: Int, total amount: Int) {
        let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        if self.bestGame < gameRecord {
            self.bestGame = gameRecord
        }
        correct = correct + count
        total = total + amount
        gamesCount = gamesCount + 1
    }
}
