//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Андрей Манкевич on 21.04.2023.
//

import Foundation

//protocol StatisticService {
//    var totalAccuracy: Double { get } // средняя точность правильных ответов за все игры в процентах
//    var gamesCount: Int { get } // кол-во завершённых игр
//    var bestGame: GameRecord? { get } // лучшая попытка
//
//    func store(correct count: Int, total amount: Int)
//}
//struct GameRecord: Codable, Comparable {
//
//    let correct: Int // количество правильных ответов
//    let total: Int // количество вопросов квиза
//    let date: Date // дата завершения раунда
//    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
//        lhs.correct < rhs.correct
//}
//
//}
//final class StatisticServiceImplementation: StatisticService {
//    private let userDefaults = UserDefaults.standard
//
//    private enum Keys: String {
//        case correct, total, bestGame, gamesCount
//    }
//
//    var total: Int {
//        get {
//            userDefaults.integer(forKey: Keys.total.rawValue)
//        }
//
//        set {
//            userDefaults.set(newValue, forKey: Keys.total.rawValue)
//        }
//    }
//
//    var correct: Int {
//        get {
//            userDefaults.integer(forKey: Keys.correct.rawValue)
//        }
//
//        set {
//            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
//        }
//    }
//
//    var totalAccuracy: Double {
//        Double(correct) / Double(total) * 100
//    }
//
//    var gamesCount: Int {
//        get {
//            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
//        }
//
//        set {
//            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
//        }
//    }
//
//    var bestGame: GameRecord? {
//        get {
//            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
//                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
//                return .init(correct: 0, total: 0, date: Date())
//            }
//
//            return record
//        }
//
//        set {
//            guard let data = try? JSONEncoder().encode(newValue) else {
//                print("Невозможно сохранить результат")
//                return
//            }
//
//            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
//        }
//    }
//
//    func store(correct count: Int, total amount: Int) {
//        self.correct += count
//        self.total += amount
//        self.gamesCount += 1
//
//        let currentBestGame = GameRecord(correct: count, total: amount, date: Date())
//
//        if let previousBestGame = bestGame {
//            if currentBestGame > previousBestGame {
//                bestGame = currentBestGame
//            }
//        } else {
//            bestGame = currentBestGame
//        }
//    }
//}

protocol StatisticService {
    var totalAccuracy: Double { get } // средняя точность правильных ответов за все игры в процентах
    var gamesCount: Int { get } // кол-во завершённых игр
    var bestGame: GameRecord? { get } // лучшая попытка
    
    func store(correct count: Int, total amount: Int)
}


struct GameRecord: Codable, Comparable {
    let correct: Int // количество правильных ответов
    let total: Int // количество вопросов квиза
    let date: Date // дата завершения раунда
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
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
    
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let currentBestGame = GameRecord(correct: count, total: amount, date: Date())
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
