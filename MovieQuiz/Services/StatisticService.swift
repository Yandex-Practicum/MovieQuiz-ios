//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Flymetric on 23.02.2026.
//

import Foundation

class StatisticService {
    
    private var storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int
    private var totalQuestionsAsked: Int
    
    init(totalCorrectAnswers: Int = 0, totalQuestionsAsked: Int = 0) {
        self.totalCorrectAnswers = totalCorrectAnswers
        self.totalQuestionsAsked = totalQuestionsAsked
        loadStatistics()
    }
    
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()

            // возвращаем обект
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard totalQuestionsAsked > 0 else { return 0 }
        return (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        totalCorrectAnswers += count // добавляем количество правильных ответов в этом раунде
        totalQuestionsAsked += amount // всего количество заданных вопросов
        
        // Здесь сохраним новые обновленные правильные ответы и всего вопросов
        storage.set(totalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(totalQuestionsAsked, forKey: Keys.totalQuestionsAsked.rawValue)
        
        gamesCount += 1 // увеличиваем счетчик количества игр
        
        // проверяем на лучшую игру
        let currentAccuracy = Double(count) / Double(amount)
        let bestGameData = bestGame
        var bestGameAccuracy: Double
        
        if bestGameData.total > 0 {
            bestGameAccuracy = Double(bestGameData.correct) / Double(bestGameData.total)
        } else {
            // Если рекорд не установлен, считаем его точность -1, чтобы текущая игра точно стала рекордной
            bestGameAccuracy = -1
        }
        
        
        if currentAccuracy > bestGameAccuracy {
            bestGame = GameResult(correct: count, total: amount, date: Date())
        }
    }
    
    private func loadStatistics() {
        totalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        totalQuestionsAsked = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
    }
}
