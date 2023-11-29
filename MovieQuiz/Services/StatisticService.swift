//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 25.11.2023.
//

import Foundation



protocol StatisticService {
    var totalAccuracy: Double {get}
    var gamesCount: Int {get set}
    var gameRecord: GameRecord? {get set} 
    
    func store(correct: Int,total: Int)
}


class StatisticServiceImplementation: StatisticService {
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.total.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.correct.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    var gameRecord: GameRecord? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
                  let gameRecord = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return gameRecord
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue)  else {
                print("Невозможно сохранить результат")
                return
            }

            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let currentGame = GameRecord(correct: correct, total: total, date: Date())
        
        if let previousBestGame = gameRecord {
            if currentGame > previousBestGame {
                gameRecord = currentGame
            }
        } else {
            gameRecord = currentGame
        }
    }
}
