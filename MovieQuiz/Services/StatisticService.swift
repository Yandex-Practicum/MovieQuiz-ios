//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Алексей on 12.12.2022.
//

import Foundation
protocol StatisticService {
    func storeGameResult(correctAnswersNumber count: Int, totalQuestionsNumber amount: Int)
    func storeRecord(correct count: Int, total amount: Int)
    func setGameCount(gamesCount: Int) 
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var correctAnswer: Double { get }
    var totalQuestions: Double { get }
}

class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
   
    
    private(set) var correctAnswer: Double {
        get {
            let correct = userDefaults.double(forKey: Keys.correct.rawValue)
            return correct
        }
        set {userDefaults.set(newValue, forKey: Keys.correct.rawValue)}
        
    }
    private(set) var totalQuestions: Double {
        get {
            let total = userDefaults.double(forKey: Keys.total.rawValue)
            return total
        }
        set {userDefaults.set(newValue, forKey: Keys.total.rawValue)}
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return .init(correct: 0, total: 0, date: Date())
                    }
            return record
        }
        set {
            guard let newData = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            guard let oldData = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let oldRecord = try? JSONDecoder().decode(GameRecord.self, from: oldData) else {
                userDefaults.set(newData, forKey: Keys.bestGame.rawValue)
                return
            }

            if newValue > oldRecord {
                userDefaults.set(newData, forKey: Keys.bestGame.rawValue)
            }
        }
    }
     var totalAccuracy: Double {
          let data =  correctAnswer / totalQuestions * 100
            return data

    }
    private(set) var gamesCount: Int {
        get {
            let data = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return data
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            
            }
    }
    
    func storeRecord(correct count: Int, total amount: Int) {
        self.bestGame = GameRecord(correct: count, total: amount, date: Date())
    }
    
    func setGameCount(gamesCount: Int) {
        self.gamesCount = gamesCount
    }
    
    
    func storeGameResult(correctAnswersNumber count: Int, totalQuestionsNumber amount: Int) {
        
        self.correctAnswer = Double(count)
        self.totalQuestions = Double(amount)
        }
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, accuracy
    }
   
}

    
    


