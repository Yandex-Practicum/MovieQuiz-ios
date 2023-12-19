//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Vladimir Vinakheras on 17.12.2023.
//

import Foundation
import UIKit

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correctAnswers, bestGame, gamesCount, totalCorrectAnswers, totalAmountQuestions
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalCorrectAnswers : Int {
        get{
            let totalCorrectAnswers = userDefaults.integer(forKey: Keys.totalCorrectAnswers.rawValue)
            return totalCorrectAnswers
        }
        
        set{
            userDefaults.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalAmountQuestions : Int {
        get{
            let totalAmountQuestions = userDefaults.integer(forKey: Keys.totalAmountQuestions.rawValue)
            return totalAmountQuestions
        }
        
        set{
            userDefaults.set(newValue, forKey: Keys.totalAmountQuestions.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get{
            if totalAmountQuestions > 0 {
                return Double(totalCorrectAnswers) / Double(totalAmountQuestions) * 100
            }else{
                return Double(0)
            }
            
        }
    }
    
    var gamesCount: Int {
        get{
            let gamesAmmount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return gamesAmmount
        }
        
        set{
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correctAnswers: 0, totalQuestions: 0, date: Date())
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
    
    
    func store(correct count: Int, total amount: Int) {
        let newRecord = GameRecord(correctAnswers: count, totalQuestions: amount, date: Date())
        isNewRecord(isNewRecord: newRecord)
        totalCorrectAnswers += count
        totalAmountQuestions += amount
        gamesCount += 1
    }
    
    func isNewRecord(isNewRecord: GameRecord) {
        if bestGame < isNewRecord {
            bestGame = isNewRecord
        }
    }
}
