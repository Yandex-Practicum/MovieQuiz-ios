//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Andrey Ovchinnikov on 11.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    // MARK: - лучший результат
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date().dateTimeString)
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
    
    // MARK: - соотношение всех ответов
    var totalAccuracy: Double {
        get {
            guard let correct = userDefaults.string(forKey: Keys.correct.rawValue) else { return 0 }
            guard let total = userDefaults.string(forKey: Keys.total.rawValue) else { return 0 }
            return (Double(correct) ?? 0) / (Double(total) ?? 0) * 100
        }
        
    }
    
    // MARK: - количество сыгранных раундов
    var gamesCount: Int {
        get {
            guard let gamesCount = userDefaults.string(forKey: Keys.gamesCount.rawValue) else { return 0 }
            
            return Int(gamesCount) ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
        
    }
    
    // MARK: - метод сохранения рекорда(если он лучше), и сохранение(добавление) вопросов и правильных ответов
    func store(correct count: Int, total amount: Int) {
        let gameRecordModel = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        
        if gameRecordModel.comparisonRecords(pastResults: bestGame, newResults: gameRecordModel) {
            bestGame = gameRecordModel
        }
        
        
         let correct = userDefaults.string(forKey: Keys.correct.rawValue) ?? "0"
            
            userDefaults.set(count + (Int(correct) ?? 0), forKey: Keys.correct.rawValue)
       
         let total = userDefaults.string(forKey: Keys.total.rawValue) ?? "0"
            
            userDefaults.set(amount + (Int(total) ?? 0), forKey: Keys.total.rawValue)
      
        
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}
