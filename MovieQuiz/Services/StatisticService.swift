//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Артур Коробейников on 08.02.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
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
        
        let correctAnswers = (userDefaults.value(forKey: Keys.correct.rawValue) as? Int) ?? 0
        let newCorrectAnswers = correctAnswers + count
        userDefaults.set(newCorrectAnswers, forKey: Keys.correct.rawValue)
        
        let totalQuestions = (userDefaults.value(forKey: Keys.total.rawValue) as? Int) ?? 0
        let newTotalQuestions = totalQuestions + amount
        userDefaults.set(newTotalQuestions, forKey: Keys.total.rawValue)
        
        if let bestGame = userDefaults.data(forKey: Keys.bestGame.rawValue),
           let record = try? JSONDecoder().decode(GameRecord.self, from: bestGame) {
            if record.checkRecord(currentCorrect: count, recordCorrect: record.correct) {
                let newRecord = GameRecord(correct: count, total: amount, date: Date())
                let data = try? JSONEncoder().encode(newRecord)
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        } else {
            let firstRecord = GameRecord(correct: count, total: amount, date: Date())
            let data = try? JSONEncoder().encode(firstRecord)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let amountOfCorrect = (userDefaults.value(forKey: Keys.correct.rawValue) as? Double) ?? 0
            let amountOfQuestions = (userDefaults.value(forKey: Keys.total.rawValue) as? Double) ?? 0
            return amountOfCorrect / amountOfQuestions * 100
        }
        set {
            
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue), let gamesCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return .zero
            }
            return gamesCount
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сосчитать кол-во игр")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
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
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}
