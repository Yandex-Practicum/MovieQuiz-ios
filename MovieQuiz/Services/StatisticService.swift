//
//  StatisticService 2.swift
//  MovieQuiz
//
//  Created by Иван Корнев on 03.12.2023.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
            case correct, total, bestGame, gamesCount
        }
        
        var totalAccuracy: Double {
            Double(correct) / Double(total) * 100
        }
        
        var gamesCount: Int {
            get {
                userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
            set{
                userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            }
        }
        
        var total: Int {
            get {
                userDefaults.integer(forKey: Keys.total.rawValue)
            }
            set{
                userDefaults.set(newValue, forKey: Keys.total.rawValue)
            }
        }
        
        var correct: Int {
            get {
                userDefaults.integer(forKey: Keys.correct.rawValue)
            }
            set{
                userDefaults.set(newValue, forKey: Keys.correct.rawValue)
            }
        }
        
        var bestGame: GameRecord? {
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
        
        
        func store(correct: Int, total: Int) {
            self.correct += correct
            self.total += total
            self.gamesCount += 1
            
            let currentBestGame = GameRecord(correct: correct, total: total, date: Date())
            if let previosBestGame = bestGame {
                if currentBestGame.correct > previosBestGame.correct {
                    bestGame = currentBestGame
                }
            } else {
                bestGame = currentBestGame
            }
        }
    }
