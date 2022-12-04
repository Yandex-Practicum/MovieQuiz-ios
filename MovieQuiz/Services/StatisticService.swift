//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Дмитрий Редька on 02.12.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(current count: Int, total amount: Int)
}


final class StaticticServiceImplementation: StatisticService {

    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case  totalAccuracy, gamesCount, bestGame, totalQuestions, totalCorrect
    }

    var totalAccuracy: Double {
        if let dataTotalCorrect = userDefaults.data(forKey: Keys.totalCorrect.rawValue),
           let totalCorrect = try? JSONDecoder().decode(Int.self, from: dataTotalCorrect),
           let dataTotalQuestions = userDefaults.data(forKey: Keys.totalQuestions.rawValue),
           let totalQuestions = try? JSONDecoder().decode(Int.self, from: dataTotalQuestions),
           totalQuestions != 0 {
                return Double(totalCorrect) / Double(totalQuestions) * 100
        }
            return 0.0

    }
    
    private (set) var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить количество сыгранных игр")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    

    
    private (set) var bestGame: GameRecord {
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

    
    func store(current count: Int, total amount: Int) {
        // Save new best game
        let currentBestGame = bestGame
        if currentBestGame.isRecord(current: count) {
            let newBestGame = GameRecord(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
        // increase games count
        gamesCount += 1
        // increase total quiz questions
        if let data = userDefaults.data(forKey: Keys.totalQuestions.rawValue),
           var totalQuestions = try? JSONDecoder().decode(Int.self, from: data) {
           totalQuestions += amount
            guard let data = try? JSONEncoder().encode(totalQuestions) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.totalQuestions.rawValue)
        } else {
            var totalQuestions = amount
            guard let data = try? JSONEncoder().encode(totalQuestions) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.totalQuestions.rawValue)
            
        }
        // increase total correct answers
        if let data = userDefaults.data(forKey: Keys.totalCorrect.rawValue),
           var totalCorrect = try? JSONDecoder().decode(Int.self, from: data) {
            totalCorrect += count
            guard let data  = try? JSONEncoder().encode(totalCorrect) else {
                print ("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.totalCorrect.rawValue)
        } else {
            var totalCorrect = count
            guard let data  = try? JSONEncoder().encode(totalCorrect) else {
                print ("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.totalCorrect.rawValue)
        }
    }
    
    
}
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    func isRecord (current currentGameCorrect: Int) -> Bool {
        correct < currentGameCorrect
    }
    
}

