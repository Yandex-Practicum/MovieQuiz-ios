//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Кирилл Марьясов on 20.02.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy
    }
    
    // Сохранение результата текущей игры и обновление статистики
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        // Обновление и сохранение количества игр
        gamesCount += 1
        
        // Обновление и сохранение общей точности
        let newTotalAccuracy = ((totalAccuracy * Double(gamesCount - 1)) + (Double(count) / Double(amount) * 100)) / Double(gamesCount)
        totalAccuracy = newTotalAccuracy
        
        // Проверка и сохранение лучшей игры
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
    // Получение и сохранение лучшей игры
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
                print("Unable to save the best game result")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    // Общая точность по всем играм
    var totalAccuracy: Double {
        get { userDefaults.double(forKey: Keys.totalAccuracy.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue) }
    }
    
    // Количество сыгранных игр
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
