//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Артур Коробейников on 08.02.2023.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    let total: Int
    let date: Date
    
    func checkRecord(currentCorrect: Int, recordCorrect: Int ) -> Bool {
        currentCorrect > recordCorrect
    }
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        
        var correctAnswers: Int {
            get {
                return (userDefaults.value(forKey: Keys.correct.rawValue) as? Int) ?? 0
            }
            set {
                userDefaults.set(newValue, forKey: Keys.correct.rawValue)
            }
        }
        
        var totalQuestions: Int {
            get {
                return (userDefaults.value(forKey: Keys.total.rawValue) as? Int) ?? 0
            }
            set {
                userDefaults.set(newValue, forKey: Keys.total.rawValue)
            }
        }
        
        correctAnswers += count
        totalQuestions += amount
        
        bestGame.correct = count
    }
    
    var totalAccuracy: Double {
        get {
            let amountOfCorrect = (userDefaults.value(forKey: Keys.correct.rawValue) as? Double) ?? 0
            let amountOfQuestions = (userDefaults.value(forKey: Keys.total.rawValue) as? Double) ?? 0
            return amountOfCorrect / amountOfQuestions * 100
        }
    }
    
    var gamesCount: Int {
        get {
            let gamesCount = (userDefaults.value(forKey: Keys.gamesCount.rawValue) as? Int) ?? 0
            return gamesCount
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            if bestGame.checkRecord(currentCorrect: newValue.correct, recordCorrect: bestGame.correct) {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print("Невозможно сохранить результат")
                    return
                }
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    }
}
