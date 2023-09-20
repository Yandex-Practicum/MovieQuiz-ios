//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by LERÄ on 11.09.23.
//

import Foundation

struct QuizResultsViewModel {
    // строка с заголовком алерта
    let title: String
    // строка с текстом о количестве набранных очков
    let text: String
    // текст для кнопки алерта
    let buttonText: String
    
}
final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentBestGame = bestGame
        // Создаем новую запись игры
        let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        // Проверяем, является ли новая запись лучше текущей
        if newGameRecord.isBetterThan(currentBestGame) {
            // Если новый результат лучше, сохраняем его в UserDefaults
            userDefaults.set(try? JSONEncoder().encode(newGameRecord), forKey: Keys.bestGame.rawValue)
        }
        let currentGameCount = gamesCount + 1
        gamesCount = currentGameCount
        
        let currentTotalAccuracy = totalAccuracy
        if amount > 0 {
            let newAccuracy = Double(amount)
            let newTotalAccuracy = (currentTotalAccuracy + newAccuracy) / Double(currentGameCount)
                totalAccuracy = newTotalAccuracy
                }
 
    }

    
    var totalAccuracy: Double {
        get {
            if let data = userDefaults.data(forKey: Keys.correct.rawValue),
               let accuracy = try? JSONDecoder().decode(Double.self, from: data) {
                return accuracy
            } else {
                return 0.0
            }
        } set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить totalAccuracy")
                return
            }
            userDefaults.set(data, forKey: Keys.correct.rawValue)
        }
    }


    
    var gamesCount: Int {
        get {
            if let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                let count = try? JSONDecoder().decode(Int.self, from: data)  {
                return count
            }
            return 0
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить gamesCount")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
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
}
