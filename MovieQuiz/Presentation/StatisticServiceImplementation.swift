//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

final class StatisticServiceImplementation:StatisticServiceProtocol {
    
    private lazy var userDefaults = UserDefaults.standard
    
    enum Keys: String {
        case correct, total, gameCount, bestGame
    }
    
    var totalAccurancy: Double {
        get {
            Double(totalCorrect) / Double(totalAmount)
        }
        set {
            print("Установлено новое значение \(newValue)")
        }
    }
    
    var gamesCount: Int {
        get{
            userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
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
    
    private var totalCorrect: Int {
        get{
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var totalAmount: Int {
        get{
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
        
    }
    
    ///Реализуем метод сохранения лучшего значения и общего количетсва сыгранных игр.
    ///
    ///Метод определяет сравнивает текущую партию квиза с лкучшим вариантом и определяет лучшую игру и передает параметры count и amount, для расчета точности правильных вопросов за все сыгранные партии.
    ///
    ///- Parameters:
    ///     - count: Количество правильных ответов в текущей партии квиза
    ///     - amount: Общее количество вопросов в партии квиза

    func store(correct count: Int, total amount: Int) {
        
        totalCorrect += count
        print(totalCorrect)
        totalAmount += amount
        print(totalAmount)
        
        if bestGame.isBetterResult(currentResult: GameRecord(correct: count, total: amount, date: Date())) {
            bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        
        totalAccurancy = Double(totalCorrect) / Double(totalAmount)
        gamesCount += 1
    }
    
}

