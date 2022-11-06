//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 03.11.2022.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    private(set) var totalCorrect: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private(set) var totalAnswers: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    internal var totalAccuracy: Double {
        get {
            return Double(totalCorrect) / Double(totalAnswers) * 100
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 5, total: 12, date: Date())
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
    
    private let userDefaults = UserDefaults.standard

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {

        gamesCount += 1
        totalCorrect += count
        totalAnswers += amount
        
        let currentGame = GameRecord(
            correct: count,
            total: amount,
            date: Date())
        
        guard let data = try? JSONEncoder().encode(currentGame) else {
            print("Невозможно собрать модель из currentGame")
            return
        }
        
        if currentGame.correct >= bestGame.correct {
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}


