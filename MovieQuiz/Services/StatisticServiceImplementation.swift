//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 13.07.2023.
//

import Foundation

// MARK: - StatisticServiceImplementation
/// Сервис подсчёта, обработки результатов квиза
final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String{
        case correctQuestions, totalQuestions, accuracy, bestGame, gamesCount
    }
    
    /// Общее количество верных ответов во всех квизах
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
    
    /// Общее количество вопросов во всех квизах
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
    
    /// Сохраняем результаты квиза в UserDefaults
    /// - Parameters:
    ///     - correct: Количество верных ответов
    ///     - total: Общее количество вопросов в квизе
    ///
    func store(correct count: Int, total amount: Int) {
        
        // Увеличиваем счётчик пройденных квизов
        self.gamesCount += 1
        
        // Формируем эксемпляр потенциального рекорда из результатов прохождения текущего квиза
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        // Сохраняем результаты текущего квиза если они превышают показатель верных ответов (correct) ранее сохраненного рекорда
        if currentGame > bestGame {
            self.bestGame = currentGame
        }
        
        // Инкрементируем счётчики верных ответов и суммарное количество вопросов во всех квизах
        correctQuestions += count
        totalQuestions += amount
    }
}

// MARK: - StatisticService Protocol
//
protocol StatisticService {
    var correctQuestions: Int { get }
    var totalQuestions: Int { get }
    var accuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

