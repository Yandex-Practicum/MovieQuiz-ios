//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Bogdan Fartdinov on 19.06.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int) -> GameRecord
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    // общая точность ответов
    var totalAccuracy: Double {
        get {
            guard let dataTotal = userDefaults.data(forKey: Keys.total.rawValue), let dataCorrect = userDefaults.data(forKey: Keys.correct.rawValue),
                let correct = try? JSONDecoder().decode(Int.self, from: dataCorrect),
                let total = try? JSONDecoder().decode(Int.self, from: dataTotal) else {
                return 0
            }
            let accuracy = (total / 100) * correct
            return Double(accuracy)
        }
    }
    
    // сумма всех сыгранных игр
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                let record = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to save gamesCount")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // общее кол-во отвеченных вопросов
    var total: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                let record = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to save total")
                return
            }
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    // общее кол-во верных ответов за все время
    var correct: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
                let record = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to save correct")
                return
            }
            userDefaults.set(data, forKey: Keys.correct.rawValue)
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
                print("Unable to save bestGame")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) -> GameRecord {
        // получить старую запись для сравнения с новым результатом
        guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
            return bestGame
        }
        if count > record.correct {
            // если кол-во верных ответов больше рекордного перезаписать объект
            bestGame = GameRecord(correct: count, total: amount, date: Date.now)
            guard let data = try? JSONEncoder().encode(bestGame) else {
                print("Unable to save new record")
                return bestGame
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            return bestGame
        }
        return bestGame
    }
}
