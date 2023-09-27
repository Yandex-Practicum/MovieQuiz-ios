//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by LERÄ on 11.09.23.
//

import Foundation

struct QuizResultsViewModel {
    // строка с заголовком алерта
    let title: String
    // строка с текстом о количестве набранных очков
    let text: String
    // текст для кнопки алерта
    let buttonText: String
    
}
final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
   
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let newTotal  = Double(count) / Double(amount) * 100.0
        totalAccuracy = newTotal
        gamesCount += 1
        
        
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if currentGame.isBetterThan(bestGame) {
        bestGame = currentGame
        }
        //let currentBestGame = bestGame
        //let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        //if newGameRecord.isBetterThan(currentBestGame) {
        //userDefaults.set(try? JSONEncoder().encode(newGameRecord), forKey: Keys.bestGame.rawValue) }
    }

    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
                  let accuracy = try? JSONDecoder().decode(Double.self, from: data) else { return 0.0}
            return accuracy
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить totalAccuracy")
                return
            }

            userDefaults.set(data, forKey: Keys.correct.rawValue)
            //userDefaults.removeObject(forKey: Keys.correct.rawValue)
            //userDefaults.synchronize()
        }
    }


    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {return 0}
                
            return count
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить gamesCount")
                return
            }

            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
            //userDefaults.removeObject(forKey: Keys.gamesCount.rawValue)
            //userDefaults.synchronize()
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
            //userDefaults.removeObject(forKey: Keys.bestGame.rawValue)
            //userDefaults.synchronize()

        }
    }
}
