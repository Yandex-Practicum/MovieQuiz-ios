//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

class StatisticServiceImplementation:StatisticServiceProtocol {
    
    private var userDefaults = UserDefaults.standard
    
    var totalAccurancy: Double {
        get {
            guard let dataAccurancy = userDefaults.data(forKey: Keys.totalAccurancy.rawValue),
                  let accurancy = try? JSONDecoder().decode(Double.self, from: dataAccurancy) else {
                return 0
            }
            return accurancy
        }
        set{
            guard let dataAccurancy = try? JSONEncoder().encode((newValue)) else { print("Невозможно устаовить значение среднего счета")
                return
            }
            userDefaults.set(dataAccurancy, forKey: Keys.totalAccurancy.rawValue)
        }
    }
    
    var gamesCount: Int {
        get{
            guard let data = userDefaults.data(forKey: Keys.gameCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return count
        }
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно установить значение счета")
                return
            }
            userDefaults.set(data, forKey: Keys.gameCount.rawValue)
        }
    }
    
    
    enum Keys: String {
        case correct, total, gameCount, bestGame, totalAccurancy
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
    
    //Реализуем метод сохранения лучшего значения и общего количетсва сыгранных игр
    func store(correct count: Int, total amount: Int) {
        if bestGame.isBetterResult(currentResult: GameRecord(correct: count, total: amount, date: Date())) {
            bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        totalAccurancy = (totalAccurancy + Double(count) / Double(amount)) / 2
        gamesCount += 1
    }
    
    
}

