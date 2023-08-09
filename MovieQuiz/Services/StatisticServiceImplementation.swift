//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 03.08.2023.
//

import Foundation

// MARK: - StatisticServiceImplementation

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String{
        case correctQuestions, totalQuestions, accuracy, bestGame, gamesCount
    }
    
    var correctQuestions: Int {
        get {
            guard let correct = userDefaults.object(forKey: Keys.correctQuestions.rawValue) as? Int else {
                return 0
            }
            return correct
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correctQuestions.rawValue)
        }
    }
    
    
    var totalQuestions: Int {
        get {
            guard let total = userDefaults.object(forKey: Keys.totalQuestions.rawValue) as? Int else {
                return 0
            }
            return total
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
    /// Средний процент правильных ответов
    var accuracy: Double {
        get {
            guard let correct = userDefaults.object(forKey: Keys.correctQuestions.rawValue) as? Double,
                  let total = userDefaults.object(forKey: Keys.totalQuestions.rawValue) as? Double,
                  total > 0 else {
                return 0
            }
            return Double((correct / total) * 100)
        }
    }
    
    /// Количество сыгранных квизов
    var gamesCount: Int {
        get {
            guard let count = userDefaults.object(forKey: Keys.gamesCount.rawValue) as? Int else {
                return 0
            }
            return count
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    /// Лучшие результаты прохождения квиза
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Возникла ошибка с JSON-кодированием рекорда игры")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    func store(correct count: Int, total amount: Int) {
        
        self.gamesCount += 1
        
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        if currentGame > bestGame {
            self.bestGame = currentGame
        }
        
        correctQuestions += count
        totalQuestions += amount
    }
}

// MARK: - StatisticService Protocol

protocol StatisticService {
    var correctQuestions: Int { get }
    var totalQuestions: Int { get }
    var accuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

