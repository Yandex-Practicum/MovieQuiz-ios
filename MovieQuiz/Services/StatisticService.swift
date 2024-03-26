//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Yerman Ibragimuly on 11.03.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }

    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }

    private let userDefaults = UserDefaults.standard

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

    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }

        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var totalAccuracy: Double {
        return Double(correct) / Double(total) * 100
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

    func store(correct count: Int, total amount: Int) {
        correct += count
        total += amount
        gamesCount += 1

        let newRecord = GameRecord(correct: count, total: amount, date: Date())

        if newRecord.isBetterThen(bestGame) {
            bestGame = newRecord
        }
    }
}
//protocol StatisticService {
//    var totalAccuracy: Double { get }
//    var gamesCount: Int { get }
//    var bestGame: GameRecord? { get }
//    
//    func store(correct: Int, total: Int)
//}
//
//final class StatisticServiceImpl {
//    private enum Keys: String {
//        case correct, total, bestGame, gamesCount
//    }
//    private let userDefaults: UserDefaults
//    private let decoder: JSONDecoder
//    private let encoder: JSONEncoder
//    
//    init(userDefaults: UserDefaults = UserDefaults.standard, decoder: JSONDecoder, encoder: JSONEncoder) {
//        self.userDefaults = userDefaults
//        self.decoder = decoder
//        self.encoder = encoder
//    }
//}
//
//extension StatisticServiceImpl: StatisticService {
//    
//    var totalAccuracy: Double {
//        Double(correct) / Double(total) * 100
//    }
//    
//    var total: Int {
//        get {
//            userDefaults.integer(forKey: Keys.total.rawValue)
//        }
//        set {
//            userDefaults.set(newValue, forKey: Keys.total.rawValue)
//        }
//    }
//    
//    var correct: Int {
//        get {
//            userDefaults.integer(forKey: Keys.correct.rawValue)
//        }
//        set {
//            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
//        }
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
//            let bestGame = try? JSONDecoder().decode(GameRecord.self, from: data) else {
//                return .init(correct: 0, total: 0, date: Date())
//            }
//
//            return bestGame
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
//    func store(correct: Int, total: Int) {
//        self.correct += correct
//        self.total += total
//        self.gamesCount += 1
//        
//        let currentBestGame = GameRecord(correct: correct, total: total, date: Date())
//        if let previousBestGame =  bestGame {
//            if currentBestGame > previousBestGame {
//                bestGame = currentBestGame
//            } else {
//                bestGame = currentBestGame
//            }
//            }
//        }
//    }
    
