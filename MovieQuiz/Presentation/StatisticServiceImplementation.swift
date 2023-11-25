//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

class StatisticServiceImplementation:StatisticServiceProtocol {
    
    private lazy var userDefaults = UserDefaults.standard
    
    //Перечесление с именами сохраняемых переменных (общее количество правильных ответов, общее количество ответов, количество сыгранных партий, структура лучшей игры.
    enum Keys: String {
        case correct, total, gameCount, bestGame
    }
    
    //Переменная оперделяющая общую статистику игры
    var totalAccurancy: Double {
        get {
            Double(totalCorrect) / Double(totalAmount)
        }
        set {
            print("Установлено новое значение \(newValue)")
        }
    }
    
    // Переменная оперделяющая общее количество сыгранных игр после установки приложения
    var gamesCount: Int {
        get{
            userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    //Структура лучшей игры
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
    
    //Общее количество правильных ответов сохраненное в памяти за все партии
    private var totalCorrect: Int {
        get{
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    //Обще количество вопросов заданных за все партии
    private var totalAmount: Int {
        get{
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
        
    }
    
    //Реализуем метод сохранения лучшего значения и общего количетсва сыгранных игр
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

